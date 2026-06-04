// import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:get/get.dart';
// import 'package:volume_booster_fresh/services/audio_boost_service.dart';
// import 'package:volume_booster_fresh/services/volume_service.dart';

// class AudioPreviewService extends GetxService {
//   AudioPlayer? _audioPlayer;
//   Timer? _inactivityTimer;
//   final AudioBoostService _boostService = Get.find();
//   final VolumeService _volumeService = Get.find();
//   bool _isPlaying = false;
//   int _currentPercentage = 50;

//   Future<AudioPreviewService> init() async {
//     _audioPlayer = AudioPlayer();
//     await _audioPlayer?.setReleaseMode(ReleaseMode.loop);
//     await _audioPlayer?.setVolume(0.5);

//     // Listen to system volume changes
//     _listenToSystemVolume();

//     return this;
//   }

//   void _listenToSystemVolume() {
//     // Update preview volume when system volume changes
//     _volumeService.mediaVolume.listen((volume) {
//       if (_isPlaying && _currentPercentage <= 100) {
//         final volumePercent = (_volumeService.getMediaVolumePercentage() / 100).clamp(0.0, 1.0);
//         _audioPlayer?.setVolume(volumePercent);
//         print('🔊 System volume changed: ${(volumePercent * 100).toInt()}%');
//       }
//     });
//   }

//   Future<void> startPreview() async {
//     _cancelInactivityTimer();

//     if (!_isPlaying) {
//       await _playTestSound();
//       _isPlaying = true;
//       print('🎵 Sound preview started');
//     }
//   }

//   Future<void> _playTestSound() async {
//     try {
//       await _audioPlayer?.stop();
//       // Use your local audio file
//       await _audioPlayer?.play(AssetSource('audio/subwoofer_test.mp3'));
//       await _audioPlayer?.setReleaseMode(ReleaseMode.loop);
//       print('✅ Playing test sound from asset');
//     } catch (e) {
//       print('❌ Error playing test sound: $e');
//       await _generateFallbackSound();
//     }
//   }

//   Future<void> _generateFallbackSound() async {
//     try {
//       // Use a reliable HTTPS source as fallback
//       await _audioPlayer?.play(UrlSource('https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3'));
//       await _audioPlayer?.setReleaseMode(ReleaseMode.loop);
//     } catch (e) {
//       print('Fallback sound also failed: $e');
//     }
//   }

//   Future<void> updateVolume(int percentage) async {
//     if (!_isPlaying) return;

//     _currentPercentage = percentage;

//     double volume;
//     if (percentage <= 100) {
//       // Normal volume - use system volume percentage
//       volume = (percentage / 100.0).clamp(0.0, 1.0);
//       await _audioPlayer?.setVolume(volume);
//       print('🔊 Preview volume: ${(volume * 100).toInt()}%');

//       if (_boostService.isBoostActive(percentage)) {
//         await _boostService.disableBoost();
//       }
//     } else {
//       // Boost mode - max volume + gain effect
//       volume = 1.0;
//       await _audioPlayer?.setVolume(volume);

//       final boostFactor = _boostService.getBoostFactorForPercentage(percentage);
//       await _boostService.setBoostLevel(boostFactor);
//       await _boostService.enableBoost();

//       print('⚡ BOOST active: ${boostFactor}x at ${percentage}%');
//     }

//     _resetInactivityTimer();
//   }

//   void _resetInactivityTimer() {
//     _cancelInactivityTimer();
//     _inactivityTimer = Timer(const Duration(seconds: 3), () {
//       stopPreview();
//     });
//   }

//   void _cancelInactivityTimer() {
//     _inactivityTimer?.cancel();
//   }

//   Future<void> stopPreview() async {
//     if (_isPlaying) {
//       await _audioPlayer?.stop();
//       _isPlaying = false;
//       await _boostService.disableBoost();
//       print('🔇 Sound preview stopped');
//     }
//     _cancelInactivityTimer();
//   }

//   Future<void> playPreviewAtVolume(int percentage) async {
//     await stopPreview();
//     await startPreview();
//     await updateVolume(percentage);
//   }

//   bool isPlaying() => _isPlaying;

//   @override
//   void onClose() {
//     _cancelInactivityTimer();
//     _audioPlayer?.dispose();
//     super.onClose();
//   }
// }





import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:volume_booster_fresh/services/audio_boost_service.dart';

class AudioPreviewService extends GetxService {
  AudioPlayer? _audioPlayer;
  Timer? _inactivityTimer;
  final AudioBoostService _boostService = Get.find();
  bool _isPlaying = false;
  int _currentPercentage = 50;

  Future<AudioPreviewService> init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer?.setReleaseMode(ReleaseMode.loop);
    return this;
  }

  Future<void> startPreview() async {
    _cancelInactivityTimer();

    if (!_isPlaying) {
      await _playTestSound();
      _isPlaying = true;
      print('🎵 Test sound started');
    }
  }

  Future<void> _playTestSound() async {
    try {
      await _audioPlayer?.stop();
      // Try to play your local audio file
      await _audioPlayer?.play(AssetSource('audio/subwoofer_test.mp3'));
      await _audioPlayer?.setReleaseMode(ReleaseMode.loop);
      print('✅ Playing test sound');
    } catch (e) {
      print('❌ Error playing test sound: $e');
      // Try fallback URL
      try {
        await _audioPlayer?.play(
          UrlSource('https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3'),
        );
        await _audioPlayer?.setReleaseMode(ReleaseMode.loop);
      } catch (e2) {
        print('Fallback also failed: $e2');
      }
    }
  }

  Future<void> updateVolume(int percentage) async {
    if (!_isPlaying) return;

    _currentPercentage = percentage;

    double volume;
    if (percentage <= 100) {
      // Normal mode: 0-100% maps to 0.0-1.0
      volume = percentage / 100.0;
    } else {
      // Boost mode: 101-200% maps to 1.0-2.0
      volume = 1.0 + ((percentage - 100) / 100.0);
    }

    volume = volume.clamp(0.0, 2.0);
    await _audioPlayer?.setVolume(volume);

    print('🔊 Test sound volume: ${(volume * 100).toInt()}%');
  }

  void startInactivityTimer() {
    _cancelInactivityTimer();
    _inactivityTimer = Timer(const Duration(seconds: 2), () {
      stopPreview();
    });
  }

  void _cancelInactivityTimer() {
    _inactivityTimer?.cancel();
  }

  Future<void> stopPreview() async {
    if (_isPlaying) {
      await _audioPlayer?.stop();
      _isPlaying = false;
      print('🔇 Test sound stopped');
    }
    _cancelInactivityTimer();
  }

  Future<void> playPreviewAtVolume(int percentage) async {
    await stopPreview();
    await startPreview();
    await updateVolume(percentage);
    startInactivityTimer();
  }

  bool isPlaying() => _isPlaying;

  @override
  void onClose() {
    _cancelInactivityTimer();
    _audioPlayer?.dispose();
    super.onClose();
  }
}
