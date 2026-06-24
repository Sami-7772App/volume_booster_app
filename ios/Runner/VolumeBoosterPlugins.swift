import AVFoundation
import AudioToolbox
import Flutter
import MediaPlayer
import UIKit

// MARK: - Shared Audio Session

enum AudioSessionCoordinator {
  static let insufficientPriority: OSStatus = 561017449
  private static var categoryConfigured = false
  private static let lock = NSLock()

  static func setupLifecycleRetry() {
    NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification,
      object: nil,
      queue: .main
    ) { _ in
      _ = try? activate(retries: 3)
    }
  }

  @discardableResult
  static func activate(retries: Int = 5) throws -> Bool {
    lock.lock()
    defer { lock.unlock() }

    let session = AVAudioSession.sharedInstance()

    if !categoryConfigured {
      try session.setCategory(
        .playback,
        mode: .default,
        options: [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP]
      )
      categoryConfigured = true
    }

    var lastError: Error?
    for attempt in 0..<retries {
      do {
        try session.setActive(true)
        return true
      } catch let error as NSError {
        lastError = error
        let isTransientPriorityError = error.code == Int(insufficientPriority)
        guard isTransientPriorityError, attempt < retries - 1 else {
          throw error
        }
        lock.unlock()
        Thread.sleep(forTimeInterval: 0.2 * Double(attempt + 1))
        lock.lock()
      }
    }

    if let lastError {
      throw lastError
    }
    return false
  }

  static func deactivate() throws {
    try AVAudioSession.sharedInstance().setActive(
      false,
      options: .notifyOthersOnDeactivation
    )
  }
}

// MARK: - Plugin Registrar

enum VolumeBoosterPluginRegistrar {
  static func register(with registry: FlutterPluginRegistry) {
    EqualizerPlugin.register(with: registry.registrar(forPlugin: "EqualizerPlugin")!)
    MediaVolumePlugin.register(with: registry.registrar(forPlugin: "MediaVolumePlugin")!)
    AudioFocusPlugin.register(with: registry.registrar(forPlugin: "AudioFocusPlugin")!)
    SystemSoundPlugin.register(with: registry.registrar(forPlugin: "SystemSoundPlugin")!)
  }
}

// MARK: - Equalizer Plugin (Loudness Boost)

class EqualizerPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel?
  private var audioEngine: AVAudioEngine?
  private var eqUnit: AVAudioUnitEQ?
  private var playerNode: AVAudioPlayerNode?
  private var currentGainDb = 0
  private var isInitialized = false

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.volume.booster/equalizer",
      binaryMessenger: registrar.messenger()
    )
    let instance = EqualizerPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
    print("EqualizerPlugin: Attached")
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initEqualizer":
      initEqualizer(result: result)
    case "setLoudnessBoost":
      let percent = (call.arguments as? [String: Any])?["percent"] as? Int ?? 100
      setLoudnessBoost(percent: percent, result: result)
    case "applyBoost":
      let percent = (call.arguments as? [String: Any])?["percent"] as? Int ?? 100
      applyBoost(percent: percent, result: result)
    case "disableEq":
      disableEq(result: result)
    case "getCurrentGain":
      result(currentGainDb)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func initEqualizer(result: @escaping FlutterResult) {
    if isInitialized {
      result(true)
      return
    }

    do {
      try AudioSessionCoordinator.activate()

      let engine = AVAudioEngine()
      let eq = AVAudioUnitEQ(numberOfBands: 6)
      let player = AVAudioPlayerNode()

      let frequencies: [Float] = [60, 250, 1000, 4000, 8000, 16000]
      for (index, band) in eq.bands.enumerated() {
        band.filterType = .parametric
        band.frequency = frequencies[min(index, frequencies.count - 1)]
        band.bandwidth = 1.0
        band.gain = 0
        band.bypass = false
      }
      eq.globalGain = 0

      engine.attach(player)
      engine.attach(eq)
      engine.connect(player, to: eq, format: nil)
      engine.connect(eq, to: engine.outputNode, format: nil)

      let format = engine.mainMixerNode.outputFormat(forBus: 0)
      let frameCount = AVAudioFrameCount(format.sampleRate * 0.1)
      if let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) {
        buffer.frameLength = frameCount
        player.scheduleBuffer(buffer, at: nil, options: .loops)
      }

      try engine.start()
      player.play()

      audioEngine = engine
      eqUnit = eq
      playerNode = player
      isInitialized = true
      currentGainDb = 0

      print("EqualizerPlugin: Initialized - Can boost up to +60dB")
      result(true)
    } catch {
      print("EqualizerPlugin: Init error - \(error.localizedDescription)")
      result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func gainDbForPercentage(_ percentage: Int) -> Int {
    switch percentage {
    case 200...: return 60
    case 180..<200: return 54
    case 160..<180: return 48
    case 140..<160: return 42
    case 120..<140: return 36
    default: return 0
    }
  }

  private func applyGainDb(_ gainDb: Int) {
    guard let eq = eqUnit else { return }
    let clampedGain = max(0, min(gainDb, 60))
    eq.globalGain = Float(clampedGain)

    let perBandGain = Float(clampedGain) / Float(max(eq.bands.count, 1))
    for band in eq.bands {
      band.gain = perBandGain
      band.bypass = clampedGain == 0
    }
    eq.bypass = clampedGain == 0
    currentGainDb = clampedGain

    if !isInitialized {
      return
    }
    if audioEngine?.isRunning == false {
      try? audioEngine?.start()
      playerNode?.play()
    }
  }

  private func setLoudnessBoost(percent: Int, result: @escaping FlutterResult) {
    let gainDb = gainDbForPercentage(percent)
    applyGainDb(gainDb)
    print("EqualizerPlugin: \(percent)% → +\(gainDb)dB boost")
    result(gainDb)
  }

  private func applyBoost(percent: Int, result: @escaping FlutterResult) {
    let gainDb = Int((Double(percent - 100) * 0.6).rounded()).clamped(to: 0...60)
    applyGainDb(gainDb)
    print("EqualizerPlugin: Boost: +\(gainDb)dB")
    result(gainDb)
  }

  private func disableEq(result: @escaping FlutterResult) {
    applyGainDb(0)
    print("EqualizerPlugin: Disabled")
    result(true)
  }
}

// MARK: - Media Volume Plugin

class MediaVolumePlugin: NSObject, FlutterPlugin {
  private var volumeView: MPVolumeView?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.volume.booster/media_volume",
      binaryMessenger: registrar.messenger()
    )
    let instance = MediaVolumePlugin()
    instance.setupVolumeView()
    registrar.addMethodCallDelegate(instance, channel: channel)
    print("MediaVolumePlugin: Attached to engine")
  }

  private func setupVolumeView() {
    DispatchQueue.main.async {
      let view = MPVolumeView(frame: CGRect(x: -1000, y: -1000, width: 1, height: 1))
      view.showsRouteButton = false
      view.showsVolumeSlider = true
      if let window = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .flatMap({ $0.windows })
        .first(where: { $0.isKeyWindow })
      {
        window.addSubview(view)
      }
      self.volumeView = view
    }
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getMaxVolume":
      result(100)
    case "getCurrentVolume":
      let current = Int((AVAudioSession.sharedInstance().outputVolume * 100).rounded())
      print("MediaVolumePlugin: Current volume = \(current)")
      result(current)
    case "setVolume":
      let volume = (call.arguments as? [String: Any])?["volume"] as? Int ?? 0
      setSystemVolume(volume)
      print("MediaVolumePlugin: Volume set to \(volume) / 100")
      result(volume.clamped(to: 0...100))
    case "getStreamType":
      result("music")
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func setSystemVolume(_ volume: Int) {
    let normalized = Float(volume.clamped(to: 0...100)) / 100.0
    DispatchQueue.main.async {
      guard let slider = self.volumeView?.subviews.compactMap({ $0 as? UISlider }).first else {
        return
      }
      slider.value = normalized
      slider.sendActions(for: .valueChanged)
    }
  }
}

// MARK: - Audio Focus Plugin

class AudioFocusPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.volume.booster/audio_focus",
      binaryMessenger: registrar.messenger()
    )
    let instance = AudioFocusPlugin()
    instance.channel = channel
    instance.setupObservers()
    AudioSessionCoordinator.setupLifecycleRetry()
    registrar.addMethodCallDelegate(instance, channel: channel)
    print("AudioFocusPlugin: Attached to engine")
  }

  private func setupObservers() {
    let center = NotificationCenter.default
    center.addObserver(
      self,
      selector: #selector(handleInterruption),
      name: AVAudioSession.interruptionNotification,
      object: AVAudioSession.sharedInstance()
    )
    center.addObserver(
      self,
      selector: #selector(handleRouteChange),
      name: AVAudioSession.routeChangeNotification,
      object: AVAudioSession.sharedInstance()
    )
    center.addObserver(
      self,
      selector: #selector(handleSilenceHint),
      name: AVAudioSession.silenceSecondaryAudioHintNotification,
      object: AVAudioSession.sharedInstance()
    )
  }

  @objc private func handleInterruption(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
          let type = AVAudioSession.InterruptionType(rawValue: typeValue)
    else { return }

    switch type {
    case .began:
      print("AudioFocusPlugin: Audio focus LOST - Other app playing audio")
      channel?.invokeMethod("onAudioFocusChange", arguments: false)
    case .ended:
      print("AudioFocusPlugin: Audio focus GAINED - No other audio playing")
      channel?.invokeMethod("onAudioFocusChange", arguments: true)
    @unknown default:
      break
    }
  }

  @objc private func handleRouteChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
          let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue)
    else { return }

    if reason == .oldDeviceUnavailable {
      channel?.invokeMethod("onAudioBecomingNoisy", arguments: nil)
    }
  }

  @objc private func handleSilenceHint(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
          let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: typeValue)
    else { return }

    let hasFocus = type == .end
    channel?.invokeMethod("onAudioFocusChange", arguments: hasFocus)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "requestAudioFocus":
      requestAudioFocus(result: result)
    case "abandonAudioFocus":
      abandonAudioFocus(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func requestAudioFocus(result: @escaping FlutterResult) {
    do {
      try AudioSessionCoordinator.activate()
      let hasFocus = !AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
      print("AudioFocusPlugin: Audio focus requested, hasFocus=\(hasFocus)")
      result(hasFocus)
    } catch let error as NSError {
      let isTransientPriorityError = error.code == Int(AudioSessionCoordinator.insufficientPriority)
      if isTransientPriorityError {
        print("AudioFocusPlugin: Audio focus deferred - another app has priority")
        result(false)
        return
      }
      print("AudioFocusPlugin: Error requesting audio focus - \(error.localizedDescription)")
      result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
    } catch {
      print("AudioFocusPlugin: Error requesting audio focus - \(error.localizedDescription)")
      result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func abandonAudioFocus(result: @escaping FlutterResult) {
    do {
      try AudioSessionCoordinator.deactivate()
      print("AudioFocusPlugin: Audio focus abandoned")
      result(true)
    } catch {
      result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: - System Sound Plugin

class SystemSoundPlugin: NSObject, FlutterPlugin {
  private var audioPlayer: AVAudioPlayer?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.volume.booster/sounds",
      binaryMessenger: registrar.messenger()
    )
    let instance = SystemSoundPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    print("SystemSoundPlugin: Attached to engine")
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("SystemSoundPlugin: Received method call - \(call.method)")
    switch call.method {
    case "playRingtone":
      playSystemSound(id: 1007, label: "ringtone", result: result)
    case "playAlarm":
      playSystemSound(id: 1005, label: "alarm", result: result)
    case "playNotification":
      playSystemSound(id: 1003, label: "notification", result: result)
    case "stopSound":
      stopSound(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func playSystemSound(id: SystemSoundID, label: String, result: @escaping FlutterResult) {
    stopCurrentPlayback()
    print("SystemSoundPlugin: Playing \(label)")
    AudioServicesPlaySystemSound(id)
    result(true)
  }

  private func stopSound(result: @escaping FlutterResult) {
    stopCurrentPlayback()
    result(true)
  }

  private func stopCurrentPlayback() {
    audioPlayer?.stop()
    audioPlayer = nil
  }
}

// MARK: - Helpers

private extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}
