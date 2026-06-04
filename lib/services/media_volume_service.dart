import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MediaVolumeService extends GetxService {
  static const MethodChannel _channel = MethodChannel('com.volume.booster/media_volume');
  
  final RxInt currentVolume = 0.obs;
  final RxInt maxVolume = 100.obs;
  
  Future<MediaVolumeService> init() async {
    await _initVolumes();
    return this;
  }
  
  Future<void> _initVolumes() async {
    try {
      // Get max volume (typically 15 or 25 on Android)
      final max = await _channel.invokeMethod('getMaxVolume');
      if (max != null) {
        maxVolume.value = max as int;
        print('✅ Max media volume: ${maxVolume.value}');
      }
      
      // Get current volume
      final current = await _channel.invokeMethod('getCurrentVolume');
      if (current != null) {
        currentVolume.value = current as int;
        print('✅ Current media volume: ${currentVolume.value}');
      }
    } catch (e) {
      print('❌ Error initializing media volume: $e');
      maxVolume.value = 15;
      currentVolume.value = 7;
    }
  }
  
  // Set media volume (0 to maxVolume)
  Future<void> setVolume(int volume) async {
    try {
      final clampedVolume = volume.clamp(0, maxVolume.value);
      await _channel.invokeMethod('setVolume', {'volume': clampedVolume});
      currentVolume.value = clampedVolume;
      print('🎛️ Media volume set to: $clampedVolume / ${maxVolume.value}');
    } catch (e) {
      print('❌ Error setting media volume: $e');
    }
  }
  
  // Get volume as percentage (0-100%)
  int getVolumePercentage() {
    if (maxVolume.value == 0) return 0;
    return ((currentVolume.value / maxVolume.value) * 100).round();
  }
  
  // Set volume by percentage (0-100%)
  Future<void> setVolumeByPercentage(int percentage) async {
    final clampedPercentage = percentage.clamp(0, 100);
    final targetVolume = (clampedPercentage / 100 * maxVolume.value).round();
    await setVolume(targetVolume);
  }
  
  @override
  void onClose() {
    super.onClose();
  }
}