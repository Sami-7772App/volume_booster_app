// // lib/controllers/volume_settings_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:volume_booster_fresh/services/volume_service.dart';

// class VolumeSettingsController extends GetxController {
//   final VolumeService _volumeService = Get.find();

//   void updateMediaVolume(double value) {
//     _volumeService.setMediaVolume(value.toInt());
//   }

//   void updateRingVolume(double value) {
//     _volumeService.setRingVolume(value.toInt());
//   }

//   void updateAlarmVolume(double value) {
//     _volumeService.setAlarmVolume(value.toInt());
//   }

//   void updateNotificationVolume(double value) {
//     _volumeService.setNotificationVolume(value.toInt());
//   }

//   void navigateToBooster() {
//     Get.toNamed('/booster');
//   }

//   @override
//   void onInit() {
//     super.onInit();
//   }
// }









    // 2nd pocwssigggggggggggggggggggggggggggggg
// import 'package:get/get.dart';
// import 'package:volume_booster_fresh/services/volume_service.dart';
// import 'package:volume_booster_fresh/services/system_sound_service.dart';

// class VolumeSettingsController extends GetxController {
//   final VolumeService _volumeService = Get.find();
//   final SystemSoundService _soundService = Get.find();

//   // Media Volume methods
//   void updateMediaVolume(double value) {
//     _volumeService.setMediaVolume(value.toInt());
//   }

//   void onMediaVolumeDragStart() {
//     _soundService.playMediaSound();
//   }

//   // Ring Volume methods
//   void updateRingVolume(double value) {
//     _volumeService.setRingVolume(value.toInt());
//   }

//   void onRingVolumeDragStart() {
//     _soundService.playRingtoneSound();
//   }

//   // Alarm Volume methods
//   void updateAlarmVolume(double value) {
//     _volumeService.setAlarmVolume(value.toInt());
//   }

//   void onAlarmVolumeDragStart() {
//     _soundService.playAlarmSound();
//   }

//   // Notification Volume methods
//   void updateNotificationVolume(double value) {
//     _volumeService.setNotificationVolume(value.toInt());
//   }

//   void onNotificationVolumeDragStart() {
//     _soundService.playNotificationSound();
//   }

//   void navigateToBooster() {
//     Get.toNamed('/booster');
//   }
// }





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