


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

  // Future<void> startPreview() async {
  //   if (!_isPlaying) {
  //     try {
  //       await _audioPlayer?.stop();
  //       await _audioPlayer?.play(AssetSource('audio/subwoofer_test.mp3'));
  //       await _audioPlayer?.setReleaseMode(ReleaseMode.loop);
  //       _isPlaying = true;
  //     } catch (e) {
  //       print('Error: $e');
  //     }
  //   }
  // }

  Future<void> updateVolumeSmooth(double volume) async {
    if (_isPlaying) {
      await _audioPlayer?.setVolume(volume.clamp(0.0, 1.0));
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
  
    await updateVolumeSmooth(percentage <= 100 ? percentage / 100.0 : 1.0);
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