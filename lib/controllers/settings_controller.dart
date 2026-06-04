import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_booster_fresh/services/settings_service.dart';

class SettingsController extends GetxController {
  final SettingsService _settingsService = Get.find();
  
  void toggleDarkMode(bool value) {
    _settingsService.setDarkMode(value);
  }
  
  void toggleVibration(bool value) {
    _settingsService.setVibrationEnabled(value);
  }
  
  void toggleSoundEffects(bool value) {
    _settingsService.setSoundEffectsEnabled(value);
  }
  
  void resetSettings() {
    _settingsService.resetSettings();
    Get.snackbar(
      'Settings Reset',
      'All settings have been restored to default',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  
  bool get isDarkMode => _settingsService.isDarkMode.value;
  bool get isVibrationEnabled => _settingsService.isVibrationEnabled.value;
  bool get isSoundEffectsEnabled => _settingsService.isSoundEffectsEnabled.value;
}