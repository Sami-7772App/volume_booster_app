import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EqualizerService extends GetxService {
  static const MethodChannel _channel = MethodChannel('com.volume.booster/equalizer');
  
  final RxBool isEnabled = false.obs;
  final RxInt currentGainDb = 0.obs;
  final RxString boostStatus = 'OFF'.obs;

  Future<EqualizerService> init() async {
    await _initEqualizer();
    return this;
  }

  Future<void> _initEqualizer() async {
    try {
      await _channel.invokeMethod('initEqualizer');
      print('✅ Equalizer ready - Up to +60dB boost available');
    } catch (e) {
      print('❌ Equalizer error: $e');
    }
  }

  Future<int> setLoudnessBoost(int percentage) async {
    try {
      final gain = await _channel.invokeMethod('setLoudnessBoost', {'percent': percentage});
      final gainDb = gain as int? ?? 0;
      currentGainDb.value = gainDb;
      isEnabled.value = gainDb > 0;
      boostStatus.value = gainDb > 0 ? '+${gainDb}dB' : 'OFF';
      return gainDb;
    } catch (e) {
      return 0;
    }
  }

  Future<int> applyBoost(int percentage) async {
    try {
      final gain = await _channel.invokeMethod('applyBoost', {'percent': percentage});
      final gainDb = gain as int? ?? 0;
      currentGainDb.value = gainDb;
      isEnabled.value = gainDb > 0;
      boostStatus.value = gainDb > 0 ? '+${gainDb}dB' : 'OFF';
      return gainDb;
    } catch (e) {
      return 0;
    }
  }

  Future<void> disableEq() async {
    try {
      await _channel.invokeMethod('disableEq');
      currentGainDb.value = 0;
      isEnabled.value = false;
      boostStatus.value = 'OFF';
    } catch (e) {
      print('Error disabling EQ: $e');
    }
  }

  Future<int> getCurrentGain() async {
    try {
      final gain = await _channel.invokeMethod('getCurrentGain');
      return gain as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }
}