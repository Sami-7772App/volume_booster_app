import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioPreviewService extends GetxService {
  AudioPlayer? _audioPlayer;
  Timer? _inactivityTimer;
  bool _isPlaying = false;

  Future<AudioPreviewService> init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer?.setReleaseMode(ReleaseMode.loop);
    return this;
  }

  Future<void> updateVolumeSmooth(double volume) async {
    if (_isPlaying) {
      await _audioPlayer?.setVolume(volume.clamp(0.0, 2.0));
    }
  }

  void startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 2), () => stopPreview());
  }

  Future<void> stopPreview() async {
    if (_isPlaying) {
      await _audioPlayer?.stop();
      _isPlaying = false;
    }
    _inactivityTimer?.cancel();
  }

  Future<void> playPreviewAtVolume(int percentage) async {
    await stopPreview();

    final clamped = percentage.clamp(0, 200);
    final previewVolume = clamped <= 100
        ? clamped / 100.0
        : 1.0 + ((clamped - 100) / 100.0);

    await _audioPlayer?.setSource(AssetSource('audio/subwoofer_test.mp3'));
    await _audioPlayer?.setVolume(previewVolume.clamp(0.0, 2.0));
    await _audioPlayer?.resume();
    _isPlaying = true;
    startInactivityTimer();
  }

  bool isPlaying() => _isPlaying;

  @override
  void onClose() {
    _inactivityTimer?.cancel();
    _audioPlayer?.dispose();
    super.onClose();
  }
}
