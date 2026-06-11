
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:volume_booster_fresh/services/equalizer_service.dart';

class AudioBoostService extends GetxService {
  final EqualizerService _equalizerService = Get.find();

  final RxBool isBoostEnabled = false.obs;
  final RxString boostStatus = 'OFF'.obs;
  final RxInt currentGainDb = 0.obs;
  int _originalVolume = 50;

  Future<AudioBoostService> init() async {
    try {
      final volume = await FlutterVolumeController.getVolume();
      if (volume != null) {
        _originalVolume = (volume * 100).round();
      }
      print('✅ AudioBoostService initialized');
    } catch (e) {
      print('Error: $e');
    }
    return this;
  }

  // Apply REAL boost with LoudnessEnhancer - ACTUAL AUDIO GAIN!
  Future<void> applyBoost(int percentage) async {
    final clampedPercent = percentage.clamp(0, 200);

    if (clampedPercent <= 100) {
      // Normal mode - actual volume control
      final volume = clampedPercent / 100.0;
      await FlutterVolumeController.setVolume(volume);
      await _equalizerService.disableEq();
      isBoostEnabled.value = false;
      boostStatus.value = 'OFF';
      currentGainDb.value = 0;
      print('🎛️ Normal volume: ${clampedPercent}% (0dB gain)');
    } else {
      // REAL BOOST MODE - System at 100% + LoudnessEnhancer gain
      // Set system volume to maximum
      await FlutterVolumeController.setVolume(1.0);

      // Apply loudness boost - THIS ACTUALLY INCREASES AUDIO GAIN!
      final gainDb = await _equalizerService.setLoudnessBoost(clampedPercent);

      isBoostEnabled.value = true;
      final boostFactor = (clampedPercent / 100).toStringAsFixed(1);
      boostStatus.value = '${boostFactor}x';
      currentGainDb.value = gainDb;

      print(
        '⚡ REAL BOOST ACTIVE: ${clampedPercent}% → ${boostFactor}x (+${gainDb}dB GAIN)',
      );
      print(
        '💡 Audio signal is now amplified by ${gainDb}dB - PHYSICALLY LOUDER!',
      );

      if (gainDb >= 30) {
        print('⚠️ HIGH GAIN MODE: +${gainDb}dB - Significantly louder!');
      }
    }
  }

  Future<void> disableBoost() async {
    isBoostEnabled.value = false;
    await _equalizerService.disableEq();
    await FlutterVolumeController.setVolume(_originalVolume / 100.0);
    boostStatus.value = 'OFF';
    currentGainDb.value = 0;
    print('🎚️ Boost DISABLED - Normal volume restored');
  }

  double getBoostFactorForPercentage(int percentage) {
    if (percentage <= 100) return 1.0;
    return (percentage / 100).clamp(1.0, 2.0);
  }

  bool isBoostActiveForPercentage(int percentage) {
    return percentage > 100;
  }
}
