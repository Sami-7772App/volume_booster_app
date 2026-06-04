
// ignore_for_file: unused_local_variable

import 'package:get/get.dart';
import 'package:volume_booster_fresh/services/media_volume_service.dart';

class VolumeService extends GetxService {
  final MediaVolumeService _mediaVolumeService = Get.find();

  // Media Volume (This controls YouTube, music, games)
  final RxInt mediaVolume = 0.obs;
  final RxInt maxMediaVolume = 100.obs;

  // Other volume types (simulated)
  final RxInt ringVolume = 0.obs;
  final RxInt alarmVolume = 0.obs;
  final RxInt notificationVolume = 0.obs;

  final RxInt maxRingVolume = 100.obs;
  final RxInt maxAlarmVolume = 100.obs;
  final RxInt maxNotificationVolume = 100.obs;

  Future<VolumeService> init() async {
    await _initVolumes();
    return this;
  }

  Future<void> _initVolumes() async {
    try {
      // Get max media volume (this is the actual Android max, e.g., 15)
      final actualMax = _mediaVolumeService.maxVolume.value;

      // For UI, we use 0-100 scale
      maxMediaVolume.value = 100;

      // Get current media volume as percentage (0-100)
      final currentPercent = _mediaVolumeService.getVolumePercentage();
      mediaVolume.value = currentPercent;

      // Initialize other volumes
      maxRingVolume.value = 100;
      maxAlarmVolume.value = 100;
      maxNotificationVolume.value = 100;

      ringVolume.value = currentPercent;
      alarmVolume.value = currentPercent;
      notificationVolume.value = currentPercent;

      // Listen to media volume changes
      _mediaVolumeService.currentVolume.listen((volume) {
        final percent = _mediaVolumeService.getVolumePercentage();
        mediaVolume.value = percent;
        print('📱 Media volume changed to: $percent%');
      });

      print(
        '✅ VolumeService initialized - Media volume: ${mediaVolume.value}%',
      );
    } catch (e) {
      print('❌ Error initializing volumes: $e');
      maxMediaVolume.value = 100;
      mediaVolume.value = 50;
    }
  }

  // Media Volume Methods - THIS CONTROLS YOUTUBE/MUSIC VOLUME
  Future<void> setMediaVolume(int volumePercent) async {
    try {
      final clampedPercent = volumePercent.clamp(0, 100);
      await _mediaVolumeService.setVolumeByPercentage(clampedPercent);
      mediaVolume.value = clampedPercent;
      print('🎛️ Media volume set to: $clampedPercent%');
    } catch (e) {
      print('❌ Error setting media volume: $e');
    }
  }

  int getMediaVolumePercentage() {
    return mediaVolume.value;
  }

  // Ring Volume Methods
  Future<void> setRingVolume(int volume) async {
    try {
      final clampedVolume = volume.clamp(0, maxRingVolume.value);
      ringVolume.value = clampedVolume;
      print('🔔 Ring volume set to: $clampedVolume%');
    } catch (e) {
      print('Error setting ring volume: $e');
    }
  }

  int getRingVolumePercentage() {
    return ringVolume.value;
  }

  // Alarm Volume Methods
  Future<void> setAlarmVolume(int volume) async {
    try {
      final clampedVolume = volume.clamp(0, maxAlarmVolume.value);
      alarmVolume.value = clampedVolume;
      print('⏰ Alarm volume set to: $clampedVolume%');
    } catch (e) {
      print('Error setting alarm volume: $e');
    }
  }

  int getAlarmVolumePercentage() {
    return alarmVolume.value;
  }

  // Notification Volume Methods
  Future<void> setNotificationVolume(int volume) async {
    try {
      final clampedVolume = volume.clamp(0, maxNotificationVolume.value);
      notificationVolume.value = clampedVolume;
      print('🔔 Notification volume set to: $clampedVolume%');
    } catch (e) {
      print('Error setting notification volume: $e');
    }
  }

  int getNotificationVolumePercentage() {
    return notificationVolume.value;
  }
}
