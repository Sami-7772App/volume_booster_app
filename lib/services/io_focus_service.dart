import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AudioFocusService extends GetxService {
  static const MethodChannel _channel = MethodChannel('com.volume.booster/audio_focus');
  
  final RxBool isMediaPlaying = false.obs;
  final RxString currentAudioSource = 'None'.obs;
  
  Future<AudioFocusService> init() async {
    // Set up method call handler for audio focus changes
    _channel.setMethodCallHandler(_handleMethodCall);
    
    // Request audio focus initially
    await _requestAudioFocus();
    
    return this;
  }
  
  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAudioFocusChange':
        final hasFocus = call.arguments as bool;
        isMediaPlaying.value = !hasFocus; // If we lose focus, someone else is playing
        if (!hasFocus) {
          currentAudioSource.value = 'YouTube / Media Player';
          print('🎵 External media detected (YouTube/Spotify/etc.)');
        } else {
          currentAudioSource.value = 'None';
          print('🔇 No external media playing');
        }
        break;
      case 'onAudioBecomingNoisy':
        isMediaPlaying.value = true;
        currentAudioSource.value = 'External Audio Source';
        print('🎵 External audio source detected');
        break;
    }
  }
  
  Future<void> _requestAudioFocus() async {
    try {
      await _channel.invokeMethod('requestAudioFocus');
      print('✅ Audio focus requested');
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