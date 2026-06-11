




import 'package:get/get.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';
import 'package:volume_booster_fresh/services/system_tone_service.dart';

class VolumeSettingsController extends GetxController {
  final VolumeService _volumeService = Get.find();
  final SystemToneService _soundService = Get.find();

  // Media Volume methods
  void updateMediaVolume(double value) {
    _volumeService.setMediaVolume(value.toInt());
  }

  void onMediaVolumeDragStart() {
    print('🎯 Media slider touched');
    _soundService.playMediaSample();
  }

  // Ring Volume methods
  void updateRingVolume(double value) {
    _volumeService.setRingVolume(value.toInt());
  }

  void onRingVolumeDragStart() {
    print('🎯 Ring slider touched - playing ringtone');
    _soundService.playRingtone();
  }

  // Alarm Volume methods
  void updateAlarmVolume(double value) {
    _volumeService.setAlarmVolume(value.toInt());
  }

  void onAlarmVolumeDragStart() {
    print('🎯 Alarm slider touched - playing alarm');
    _soundService.playAlarmTone();
  }

  // Notification Volume methods
  void updateNotificationVolume(double value) {
    _volumeService.setNotificationVolume(value.toInt());
  }

  void onNotificationVolumeDragStart() {
    print('🎯 Notification slider touched - playing notification');
    _soundService.playNotificationTone();
  }

  void navigateToBooster() {
    Get.toNamed('/booster');
  }
}