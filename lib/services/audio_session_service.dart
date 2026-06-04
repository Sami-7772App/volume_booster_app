import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';

class AudioSessionService extends GetxService {
  final RxBool isOtherAudioPlaying = false.obs;
  AudioSession? _session;
  
  Future<AudioSessionService> init() async {
    _session = await AudioSession.instance;
    
    // Configure audio session
    await _session?.configure(AudioSessionConfiguration.speech());
    
    // Listen to audio interruption events (when other apps play audio)
    _session?.interruptionEventStream.listen((event) {
      if (event.begin) {
        // Another app started playing audio
        isOtherAudioPlaying.value = true;
        print('🎵 Other audio source started playing');
      } else {
        // Interruption ended
        isOtherAudioPlaying.value = false;
        print('🎵 Other audio source stopped');
      }
    });
    
    // Also listen to audio route changes
    _session?.becomingNoisyEventStream.listen((event) {
      // Another app is playing audio
      isOtherAudioPlaying.value = true;
      print('🎵 External audio source detected');
    });
    
    print('✅ AudioSessionService initialized');
    return this;
  }
  
  Future<void> activateAudioFocus() async {
    await _session?.setActive(true);
  }
  
  Future<void> deactivateAudioFocus() async {
    await _session?.setActive(false);
  }
  
  bool get isAudioPlaying => isOtherAudioPlaying.value;
  
  @override
  void onClose() {
    _session?.setActive(false);
    super.onClose();
  }
}