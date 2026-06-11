import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AudioFocusService extends GetxService {
  static const MethodChannel _channel = MethodChannel('com.volume.booster/audio_focus');
  
  final RxBool isMediaPlaying = false.obs;
  final RxString currentAudioSource = 'None'.obs;
  final RxString mediaStatus = '🔇 No media playing'.obs;
  
  Future<AudioFocusService> init() async {
    _channel.setMethodCallHandler(_handleMethodCall);
    await _requestAudioFocus();
    return this;
  }
  
  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAudioFocusChange':
        final hasFocus = call.arguments as bool;
        // When we LOSE focus, someone else is playing (YouTube, Spotify)
        isMediaPlaying.value = !hasFocus;
        if (!hasFocus) {
          currentAudioSource.value = 'YouTube / Media Player';
          mediaStatus.value = '🎵 Media playing (YouTube/Spotify) - Test sound disabled';
          print('🎵 EXTERNAL MEDIA DETECTED - Test sound will STOP');
        } else {
          currentAudioSource.value = 'None';
          mediaStatus.value = '🔇 No media - Test sound available';
          print('🔇 No external media - Test sound available');
        }
        break;
      case 'onAudioBecomingNoisy':
        isMediaPlaying.value = true;
        currentAudioSource.value = 'External Audio Source';
        mediaStatus.value = '🎵 Media playing - Test sound disabled';
        print('🎵 External audio source detected');
        break;
    }
  }
  
  Future<void> _requestAudioFocus() async {
    try {
      final result = await _channel.invokeMethod('requestAudioFocus');
      print('✅ Audio focus requested: $result');
    } catch (e) {
      print('❌ Error requesting audio focus: $e');
    }
  }
  
  Future<void> abandonAudioFocus() async {
    try {
      await _channel.invokeMethod('abandonAudioFocus');
      print('🔇 Audio focus abandoned');
    } catch (e) {
      print('Error abandoning audio focus: $e');
    }
  }
  
  bool get isAnyMediaPlaying => isMediaPlaying.value;
  
  @override
  void onClose() {
    abandonAudioFocus();
    super.onClose();
  }
}