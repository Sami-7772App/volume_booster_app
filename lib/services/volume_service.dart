
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';

class VolumeService extends GetxService {
  final RxInt mediaVolume = 50.obs;
  final RxInt maxMediaVolume = 100.obs;

  final RxInt ringVolume = 50.obs;
  final RxInt alarmVolume = 50.obs;
  final RxInt notificationVolume = 50.obs;

  final RxInt maxRingVolume = 100.obs;
  final RxInt maxAlarmVolume = 100.obs;
  final RxInt maxNotificationVolume = 100.obs;

  Future<VolumeService> init() async {
    await _initVolumes();
    _listenToVolumeChanges();
    return this;
  }

  Future<void> _initVolumes() async {
    try {
      maxMediaVolume.value = 100;

      // Get current volume
      final double? currentVol = await FlutterVolumeController.getVolume();
      if (currentVol != null) {
        mediaVolume.value = (currentVol * 100).round();
        print('✅ Current volume: ${mediaVolume.value}%');
      }

      // Initialize other volumes
      ringVolume.value = mediaVolume.value;
      alarmVolume.value = mediaVolume.value;
      notificationVolume.value = mediaVolume.value;
    } catch (e) {
      print('❌ Error: $e');
      mediaVolume.value = 50;
    }
  }

  void _listenToVolumeChanges() {
    FlutterVolumeController.addListener((double? volume) {
      if (volume != null) {
        mediaVolume.value = (volume * 100).round();
        print('📱 Volume changed: ${mediaVolume.value}%');
      }
    });
  }

  Future<void> setMediaVolume(int volumePercent) async {
    try {
      final clamped = volumePercent.clamp(0, 100);
      await FlutterVolumeController.setVolume(clamped / 100.0);
      mediaVolume.value = clamped;
      print('🎛️ Volume set: $clamped%');
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  int getMediaVolumePercentage() => mediaVolume.value;

  Future<void> setRingVolume(int volume) async {
    ringVolume.value = volume.clamp(0, 100);
  }

  int getRingVolumePercentage() => ringVolume.value;

  Future<void> setAlarmVolume(int volume) async {
    alarmVolume.value = volume.clamp(0, 100);
  }

  int getAlarmVolumePercentage() => alarmVolume.value;

  Future<void> setNotificationVolume(int volume) async {
    notificationVolume.value = volume.clamp(0, 100);
  }

  int getNotificationVolumePercentage() => notificationVolume.value;

  @override
  void onClose() {
    FlutterVolumeController.removeListener();
    super.onClose();
  }
}
