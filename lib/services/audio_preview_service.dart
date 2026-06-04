



// ignore_for_file: unused_field

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
