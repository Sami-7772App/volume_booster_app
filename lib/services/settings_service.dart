import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsService extends GetxService {
  final GetStorage _storage = GetStorage();
  
  final RxBool isDarkMode = true.obs;
  final RxBool isVibrationEnabled = true.obs;
  final RxBool isSoundEffectsEnabled = true.obs;
  
  Future<SettingsService> init() async {
    isDarkMode.value = _storage.read('dark_mode') ?? true;
    isVibrationEnabled.value = _storage.read('vibration_enabled') ?? true;
    isSoundEffectsEnabled.value = _storage.read('sound_effects_enabled') ?? true;
    return this;
  }
  
  void setDarkMode(bool enabled) {
    isDarkMode.value = enabled;
    _storage.write('dark_mode', enabled);
    Get.changeThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }
  
  void setVibrationEnabled(bool enabled) {
    isVibrationEnabled.value = enabled;
    _storage.write('vibration_enabled', enabled);
  }
  
  void setSoundEffectsEnabled(bool enabled) {
    isSoundEffectsEnabled.value = enabled;
    _storage.write('sound_effects_enabled', enabled);
  }
  
  void resetSettings() {
    setDarkMode(true);
    setVibrationEnabled(true);
    setSoundEffectsEnabled(true);
  }
}