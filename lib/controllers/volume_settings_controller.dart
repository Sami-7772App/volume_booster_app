

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';
import 'package:volume_booster_fresh/services/system_tone_service.dart';

class VolumeSettingsController extends GetxController {
  final VolumeService _volumeService = Get.find();
  final SystemToneService _soundService = Get.find();

  // Silent mode state
  final RxBool isPhoneSilent = false.obs;

  // Media Volume methods
  void updateMediaVolume(double value) {
    if (!isPhoneSilent.value) {
      _volumeService.setMediaVolume(value.toInt());
    }
  }

  void onMediaVolumeDragStart() {
    if (!isPhoneSilent.value) {
      print('🎯 Media slider touched');
      _soundService.playMediaSample();
    }
  }

  // Ring Volume methods
  void updateRingVolume(double value) {
    if (!isPhoneSilent.value) {
      _volumeService.setRingVolume(value.toInt());
    }
  }

  void onRingVolumeDragStart() {
    if (!isPhoneSilent.value) {
      print('🎯 Ring slider touched - playing ringtone');
      _soundService.playRingtone();
    }
  }

  // Alarm Volume methods
  void updateAlarmVolume(double value) {
    if (!isPhoneSilent.value) {
      _volumeService.setAlarmVolume(value.toInt());
    }
  }

  void onAlarmVolumeDragStart() {
    if (!isPhoneSilent.value) {
      print('🎯 Alarm slider touched - playing alarm');
      _soundService.playAlarmTone();
    }
  }

  // Notification Volume methods
  void updateNotificationVolume(double value) {
    if (!isPhoneSilent.value) {
      _volumeService.setNotificationVolume(value.toInt());
    }
  }

  void onNotificationVolumeDragStart() {
    if (!isPhoneSilent.value) {
      print('🎯 Notification slider touched - playing notification');
      _soundService.playNotificationTone();
    }
  }

  void navigateToBooster() {
    Get.toNamed('/booster');
  }

  // Toggle silent mode
  void toggleSilentMode() {
    isPhoneSilent.toggle();

    if (isPhoneSilent.value) {
      // Set all volumes to 0 when silent mode is enabled
      _volumeService.setMediaVolume(0);
      _volumeService.setRingVolume(0);
      _volumeService.setAlarmVolume(0);
      _volumeService.setNotificationVolume(0);
      Get.snackbar(
        '🔇 Silent Mode',
        'Phone is now in silent mode',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.volume_off, color: Colors.white),
      );
    } else {
      // Restore volumes when silent mode is disabled
      // You can restore to previous values or set default values
      _volumeService.setMediaVolume(10);
      _volumeService.setRingVolume(8);
      _volumeService.setAlarmVolume(10);
      _volumeService.setNotificationVolume(8);
      Get.snackbar(
        '🔊 Sound Enabled',
        'Phone is now in normal mode',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.volume_up, color: Colors.white),
      );
    }
  }
}
