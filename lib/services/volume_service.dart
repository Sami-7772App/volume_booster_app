// // ignore_for_file: unnecessary_null_comparison, unnecessary_cast

// import 'package:flutter_volume_controller/flutter_volume_controller.dart';
// import 'package:get/get.dart';

// class VolumeService extends GetxService {
//   final RxInt mediaVolume = 0.obs;
//   final RxInt ringVolume = 0.obs;
//   final RxInt alarmVolume = 0.obs;
//   final RxInt notificationVolume = 0.obs;

//   final RxInt maxMediaVolume = 100.obs;
//   final RxInt maxRingVolume = 100.obs;
//   final RxInt maxAlarmVolume = 100.obs;
//   final RxInt maxNotificationVolume = 100.obs;

//   bool _isListening = false;

//   Future<VolumeService> init() async {
//     await _initVolumes();
//     _listenToVolumeChanges();
//     return this;
//   }

//   Future<void> _initVolumes() async {
//     try {
//       // Set default max volume
//       maxMediaVolume.value = 15;

//       // Get current volume
//       final currentVol = await FlutterVolumeController.getVolume();
//       if (currentVol != null) {
//         mediaVolume.value = (currentVol as double).round();
//       } else {
//         mediaVolume.value = 7;
//       }

//       // Initialize other volumes with same values
//       maxRingVolume.value = maxMediaVolume.value;
//       maxAlarmVolume.value = maxMediaVolume.value;
//       maxNotificationVolume.value = maxMediaVolume.value;

//       ringVolume.value = mediaVolume.value;
//       alarmVolume.value = mediaVolume.value;
//       notificationVolume.value = mediaVolume.value;
//     } catch (e) {
//       print('Error initializing volumes: $e');
//       // Set default values on error
//       maxMediaVolume.value = 15;
//       mediaVolume.value = 7;
//     }
//   }

//   void _listenToVolumeChanges() {
//     if (_isListening) return;
//     _isListening = true;

//     FlutterVolumeController.addListener((volume) {
//       if (volume != null) {
//         mediaVolume.value = volume.round();
//       }
//     });
//   }

//   // Media Volume Methods
//   Future<void> setMediaVolume(int volume) async {
//     try {
//       final clampedVolume = volume.clamp(0, maxMediaVolume.value);
//       await FlutterVolumeController.setVolume(clampedVolume.toDouble());
//       mediaVolume.value = clampedVolume;
//     } catch (e) {
//       print('Error setting media volume: $e');
//     }
//   }

//   int getMediaVolumePercentage() {
//     if (maxMediaVolume.value == 0) return 0;
//     return ((mediaVolume.value / maxMediaVolume.value) * 100).round();
//   }

//   // Ring Volume Methods
//   Future<void> setRingVolume(int volume) async {
//     try {
//       final clampedVolume = volume.clamp(0, maxRingVolume.value);
//       ringVolume.value = clampedVolume;
//       print('Ring volume set to: $clampedVolume');
//     } catch (e) {
//       print('Error setting ring volume: $e');
//     }
//   }

//   int getRingVolumePercentage() {
//     if (maxRingVolume.value == 0) return 0;
//     return ((ringVolume.value / maxRingVolume.value) * 100).round();
//   }

//   // Alarm Volume Methods
//   Future<void> setAlarmVolume(int volume) async {
//     try {
//       final clampedVolume = volume.clamp(0, maxAlarmVolume.value);
//       alarmVolume.value = clampedVolume;
//       print('Alarm volume set to: $clampedVolume');
//     } catch (e) {
//       print('Error setting alarm volume: $e');
//     }
//   }

//   int getAlarmVolumePercentage() {
//     if (maxAlarmVolume.value == 0) return 0;
//     return ((alarmVolume.value / maxAlarmVolume.value) * 100).round();
//   }

//   // Notification Volume Methods
//   Future<void> setNotificationVolume(int volume) async {
//     try {
//       final clampedVolume = volume.clamp(0, maxNotificationVolume.value);
//       notificationVolume.value = clampedVolume;
//       print('Notification volume set to: $clampedVolume');
//     } catch (e) {
//       print('Error setting notification volume: $e');
//     }
//   }

//   int getNotificationVolumePercentage() {
//     if (maxNotificationVolume.value == 0) return 0;
//     return ((notificationVolume.value / maxNotificationVolume.value) * 100)
//         .round();
//   }

//   @override
//   void onClose() {
//     FlutterVolumeController.removeListener();
//     super.onClose();
//   }
// }


//2nd working processig

// import 'package:flutter_volume_controller/flutter_volume_controller.dart';
// import 'package:get/get.dart';

// class VolumeService extends GetxService {
//   final RxInt mediaVolume = 0.obs;
//   final RxInt ringVolume = 0.obs;
//   final RxInt alarmVolume = 0.obs;
//   final RxInt notificationVolume = 0.obs;

//   final RxInt maxMediaVolume = 100.obs;
//   final RxInt maxRingVolume = 100.obs;
//   final RxInt maxAlarmVolume = 100.obs;
//   final RxInt maxNotificationVolume = 100.obs;

//   bool _isListening = false;

//   Future<VolumeService> init() async {
//     await _initVolumes();
//     _listenToVolumeChanges();
//     return this;
//   }

//   Future<void> _initVolumes() async {
//     try {
//       // Get max system volume (usually 100)
//       maxMediaVolume.value = 100;

//       // Get current system volume (0.0 to 1.0)
//       final currentVol = await FlutterVolumeController.getVolume();
//       if (currentVol != null) {
//         // Convert from 0.0-1.0 to 0-100
//         mediaVolume.value = (currentVol * 100).round();
//       } else {
//         mediaVolume.value = 50;
//       }

//       // Initialize other volumes with same values
//       maxRingVolume.value = maxMediaVolume.value;
//       maxAlarmVolume.value = maxMediaVolume.value;
//       maxNotificationVolume.value = maxMediaVolume.value;

//       ringVolume.value = mediaVolume.value;
//       alarmVolume.value = mediaVolume.value;
//       notificationVolume.value = mediaVolume.value;
      
//       print('✅ VolumeService initialized: System volume = ${mediaVolume.value}%');
//     } catch (e) {
//       print('❌ Error initializing volumes: $e');
//       maxMediaVolume.value = 100;
//       mediaVolume.value = 50;
//     }
//   }

//   void _listenToVolumeChanges() {
//     if (_isListening) return;
//     _isListening = true;

//     FlutterVolumeController.addListener((volume) {
//       if (volume != null) {
//         // Convert from 0.0-1.0 to 0-100
//         final volumePercent = (volume * 100).round();
//         mediaVolume.value = volumePercent;
//         print('📱 System volume changed: $volumePercent%');
//       }
//     });
//   }

//   // THIS ACTUALLY CONTROLS THE SYSTEM AUDIO VOLUME
//   Future<void> setMediaVolume(int volume) async {
//     try {
//       // Volume is 0-100, need to convert to 0.0-1.0 for system
//       final clampedVolume = volume.clamp(0, maxMediaVolume.value);
//       final systemVolume = clampedVolume / 100.0;
      
//       await FlutterVolumeController.setVolume(systemVolume);
//       mediaVolume.value = clampedVolume;
      
//       print('🎛️ System volume set to: $clampedVolume% (${(systemVolume * 100).toInt()}%)');
//     } catch (e) {
//       print('❌ Error setting system volume: $e');
//     }
//   }

//   int getMediaVolumePercentage() {
//     if (maxMediaVolume.value == 0) return 0;
//     return mediaVolume.value;
//   }

//   // Ring Volume Methods (simulated - Android requires special permissions)
//   Future<void> setRingVolume(int volume) async {
//     try {
//       final clampedVolume = volume.clamp(0, maxRingVolume.value);
//       ringVolume.value = clampedVolume;
//       print('🔔 Ring volume set to: $clampedVolume% (Note: May require additional permissions)');
//     } catch (e) {
//       print('Error setting ring volume: $e');
//     }
//   }

//   int getRingVolumePercentage() {
//     if (maxRingVolume.value == 0) return 0;
//     return ringVolume.value;
//   }

//   // Alarm Volume Methods
//   Future<void> setAlarmVolume(int volume) async {
//     try {
//       final clampedVolume = volume.clamp(0, maxAlarmVolume.value);
//       alarmVolume.value = clampedVolume;
//       print('⏰ Alarm volume set to: $clampedVolume%');
//     } catch (e) {
//       print('Error setting alarm volume: $e');
//     }
//   }

//   int getAlarmVolumePercentage() {
//     if (maxAlarmVolume.value == 0) return 0;
//     return alarmVolume.value;
//   }

//   // Notification Volume Methods
//   Future<void> setNotificationVolume(int volume) async {
//     try {
//       final clampedVolume = volume.clamp(0, maxNotificationVolume.value);
//       notificationVolume.value = clampedVolume;
//       print('🔔 Notification volume set to: $clampedVolume%');
//     } catch (e) {
//       print('Error setting notification volume: $e');
//     }
//   }

//   int getNotificationVolumePercentage() {
//     if (maxNotificationVolume.value == 0) return 0;
//     return notificationVolume.value;
//   }

//   @override
//   void onClose() {
//     FlutterVolumeController.removeListener();
//     super.onClose();
//   }
// }


import 'package:flutter_volume_controller/flutter_volume_controller.dart';
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
      
      print('✅ VolumeService initialized - Media volume: ${mediaVolume.value}%');
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