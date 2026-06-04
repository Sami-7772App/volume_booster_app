import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SystemSoundService extends GetxService {
  AudioPlayer? _audioPlayer;
  
  Future<SystemSoundService> init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer?.setVolume(1.0);
    return this;
  }
  
  // Play Media Sample Sound
  Future<void> playMediaSound() async {
    try {
      await _audioPlayer?.stop();
      // Using a music sample URL
      await _audioPlayer?.play(UrlSource('https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3'));
      print('Playing Media Sound');
    } catch (e) {
      print('Error playing media sound: $e');
    }
  }
  
  // Play Ringtone Sound
  Future<void> playRingtoneSound() async {
    try {
      await _audioPlayer?.stop();
      // Ringtone sound URL
      await _audioPlayer?.play(UrlSource('https://www.soundjay.com/phone/phone-ringtone-1.mp3'));
      print('Playing Ringtone Sound');
    } catch (e) {
      print('Error playing ringtone: $e');
    }
  }
  
  // Play Alarm Sound
  Future<void> playAlarmSound() async {
    try {
      await _audioPlayer?.stop();
      // Alarm sound URL
      await _audioPlayer?.play(UrlSource('https://www.soundjay.com/misc/sounds/alarm-clock-1.mp3'));
      print('Playing Alarm Sound');
    } catch (e) {
      print('Error playing alarm: $e');
    }
  }
  
  // Play Notification Sound
  Future<void> playNotificationSound() async {
    try {
      await _audioPlayer?.stop();
      // Notification sound URL
      await _audioPlayer?.play(UrlSource('https://www.soundjay.com/phone/notification-1.mp3'));
      print('Playing Notification Sound');
    } catch (e) {
      print('Error playing notification: $e');
    }
  }
  
  Future<void> stopSound() async {
    await _audioPlayer?.stop();
  }
  
  @override
  void onClose() {
    _audioPlayer?.dispose();
    super.onClose();
  }
}



