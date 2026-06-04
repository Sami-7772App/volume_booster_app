// import 'package:get/get.dart';
// import 'package:vibration/vibration.dart';
// import 'package:volume_booster_fresh/services/audio_boost_service.dart';
// import 'package:volume_booster_fresh/services/audio_preview_service.dart';
// import 'package:volume_booster_fresh/services/settings_service.dart';
// import 'package:volume_booster_fresh/services/volume_service.dart';

// class BoosterController extends GetxController {
//   final VolumeService _volumeService = Get.find();
//   final AudioBoostService _boostService = Get.find();
//   final AudioPreviewService _previewService = Get.find();
//   final SettingsService _settingsService = Get.find();

//   final RxInt currentVolume = 100.obs;
//   final RxBool isKnobDragging = false.obs;
//   final RxString currentBoostStatus = 'OFF'.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadInitialVolume();
//     _listenToSystemVolumeChanges();
//   }

//   void _loadInitialVolume() {
//     currentVolume.value = _volumeService.getMediaVolumePercentage();
//   }

//   void _listenToSystemVolumeChanges() {
//     // Update UI when system volume changes (e.g., using hardware buttons)
//     _volumeService.mediaVolume.listen((volume) {
//       final percentage = _volumeService.getMediaVolumePercentage();
//       if (!isKnobDragging.value) {
//         currentVolume.value = percentage;
//         print('📱 System volume changed to: $percentage%');
//       }
//     });
//   }

//   void updateVolume(int newVolume) {
//     final clampedVolume = newVolume.clamp(0, 200);
//     currentVolume.value = clampedVolume;

//     // Apply vibration if enabled during drag
//     if (_settingsService.isVibrationEnabled.value && isKnobDragging.value) {
//       Vibration.vibrate(duration: 10);
//     }

//     // Update actual device volume (0-100%)
//     if (clampedVolume <= 100) {
//       final actualVolume = (clampedVolume / 100) * _volumeService.maxMediaVolume.value;
//       _volumeService.setMediaVolume(actualVolume.toInt());
//       currentBoostStatus.value = 'OFF';
//     } else {
//       // Keep device at max volume for 100%+
//       _volumeService.setMediaVolume(_volumeService.maxMediaVolume.value);
//       final boostFactor = _boostService.getBoostFactorForPercentage(clampedVolume);
//       currentBoostStatus.value = '${boostFactor.toStringAsFixed(1)}x';
//     }

//     // Update audio preview in real-time while dragging
//     if (isKnobDragging.value) {
//       _previewService.updateVolume(clampedVolume);
//     }
//   }

//   void startKnobDrag() {
//     isKnobDragging.value = true;
//     // Start playing sound when knob is touched
//     _previewService.startPreview();

//     // Apply initial volume based on current value
//     _previewService.updateVolume(currentVolume.value);

//     // Haptic feedback
//     if (_settingsService.isVibrationEnabled.value) {
//       Vibration.vibrate(duration: 20);
//     }

//     print('🎵 Sound preview started at ${currentVolume.value}%');
//   }

//   void endKnobDrag() {
//     isKnobDragging.value = false;
//     // Stop sound after 3 seconds of inactivity
//     _previewService.stopPreview();
//     print('🎵 Sound preview stopped');
//   }

//   void manualPlayTestSound() {
//     _previewService.playPreviewAtVolume(currentVolume.value);

//     if (_settingsService.isVibrationEnabled.value) {
//       Vibration.vibrate(duration: 15);
//     }
//   }

//   bool isBoostActive() {
//     return _boostService.isBoostActive(currentVolume.value);
//   }

//   String getBoostFactorText() {
//     if (!isBoostActive()) return 'OFF';
//     final factor = _boostService.getBoostFactorForPercentage(currentVolume.value);
//     return '${factor.toStringAsFixed(1)}x';
//   }

//   int getDisplayPercentage() {
//     return currentVolume.value;
//   }

//   @override
//   void onClose() {
//     _previewService.stopPreview();
//     super.onClose();
//   }
// }

// //2nd workingggggggggggggggggggggggggggggggggggggggg
// import 'package:get/get.dart';
// import 'package:vibration/vibration.dart';
// import 'package:volume_booster_fresh/services/audio_boost_service.dart';
// import 'package:volume_booster_fresh/services/audio_preview_service.dart';
// import 'package:volume_booster_fresh/services/settings_service.dart';
// import 'package:volume_booster_fresh/services/volume_service.dart';

// class BoosterController extends GetxController {
//   final VolumeService _volumeService = Get.find();
//   final AudioBoostService _boostService = Get.find();
//   final AudioPreviewService _previewService = Get.find();
//   final SettingsService _settingsService = Get.find();

//   final RxInt currentVolume = 0.obs;
//   final RxBool isKnobDragging = false.obs;
//   final RxString currentBoostStatus = 'OFF'.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadInitialVolume();
//   }

//   void _loadInitialVolume() {
//     currentVolume.value = _volumeService.getMediaVolumePercentage();
//   }

//   void updateVolume(int newVolume) {
//     final clampedVolume = newVolume.clamp(0, 200);
//     currentVolume.value = clampedVolume;

//     // Apply vibration if enabled during drag
//     if (_settingsService.isVibrationEnabled.value && isKnobDragging.value) {
//       Vibration.vibrate(duration: 5);
//     }

//     // Update actual device volume (0-100%)
//     if (clampedVolume <= 100) {
//       final actualVolume = (clampedVolume / 100) * _volumeService.maxMediaVolume.value;
//       _volumeService.setMediaVolume(actualVolume.toInt());
//       currentBoostStatus.value = 'OFF';
//     } else {
//       // Keep device at max volume for 100%+
//       _volumeService.setMediaVolume(_volumeService.maxMediaVolume.value);
//       final boostFactor = _boostService.getBoostFactorForPercentage(clampedVolume);
//       currentBoostStatus.value = '${boostFactor.toStringAsFixed(1)}x';
//     }

//     // Update audio preview volume IMMEDIATELY while dragging
//     if (isKnobDragging.value) {
//       _previewService.updateVolume(clampedVolume);
//     }
//   }

//   void startKnobDrag() {
//     isKnobDragging.value = true;
//     // Start playing sound immediately when knob is touched
//     _previewService.startPreview().then((_) {
//       // Set initial volume
//       _previewService.updateVolume(currentVolume.value);
//     });

//     // Haptic feedback
//     if (_settingsService.isVibrationEnabled.value) {
//       Vibration.vibrate(duration: 20);
//     }

//     print('🎵 Sound preview started at ${currentVolume.value}%');
//   }

//   void endKnobDrag() {
//     isKnobDragging.value = false;
//     // Stop sound preview
//     _previewService.stopPreview();
//     print('🎵 Sound preview stopped');
//   }

//   void manualPlayTestSound() {
//     _previewService.playPreviewAtVolume(currentVolume.value);

//     if (_settingsService.isVibrationEnabled.value) {
//       Vibration.vibrate(duration: 15);
//     }
//   }

//   bool isBoostActive() {
//     return _boostService.isBoostActive(currentVolume.value);
//   }

//   String getBoostFactorText() {
//     if (!isBoostActive()) return 'OFF';
//     final factor = _boostService.getBoostFactorForPercentage(currentVolume.value);
//     return '${factor.toStringAsFixed(1)}x';
//   }

//   int getDisplayPercentage() {
//     return currentVolume.value;
//   }

//   @override
//   void onClose() {
//     _previewService.stopPreview();
//     super.onClose();
//   }
// }





import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_booster_fresh/services/audio_boost_service.dart';
import 'package:volume_booster_fresh/services/audio_preview_service.dart';
import 'package:volume_booster_fresh/services/settings_service.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';

class BoosterController extends GetxController {
  final VolumeService _volumeService = Get.find();
  final AudioBoostService _boostService = Get.find();
  final AudioPreviewService _previewService = Get.find();
  final SettingsService _settingsService = Get.find();

  final RxInt currentVolume = 0.obs;
  final RxBool isKnobDragging = false.obs;
  final RxString currentBoostStatus = 'OFF'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialVolume();
    _listenToSystemVolumeChanges();
  }

  void _loadInitialVolume() {
    currentVolume.value = _volumeService.getMediaVolumePercentage();
    print('🎛️ Initial volume: ${currentVolume.value}%');
  }
  
  void _listenToSystemVolumeChanges() {
    // Update UI when system volume changes via hardware buttons
    _volumeService.mediaVolume.listen((volume) {
      final percentage = _volumeService.getMediaVolumePercentage();
      if (!isKnobDragging.value) {
        currentVolume.value = percentage;
        print('📱 Hardware volume button used: $percentage%');
      }
    });
  }

  void updateVolume(int newVolume) {
    final clampedVolume = newVolume.clamp(0, 200);
    currentVolume.value = clampedVolume;

    // Apply haptic feedback
    if (_settingsService.isVibrationEnabled.value && isKnobDragging.value) {
      Vibration.vibrate(duration: 5);
    }

    // ACTUAL SYSTEM VOLUME CONTROL
    if (clampedVolume <= 100) {
      // Normal mode: 0-100% -> Direct system volume control
      _volumeService.setMediaVolume(clampedVolume);
      _boostService.disableBoost();
      currentBoostStatus.value = 'OFF';
      print('🎛️ Normal mode: System volume = $clampedVolume%');
    } else {
      // BOOST MODE: 101-200% -> System at 100% + Boost factor
      // Set system volume to maximum (100%)
      _volumeService.setMediaVolume(100);
      
      // Calculate boost factor (1.0x to 2.0x)
      final boostFactor = _boostService.getBoostFactorForPercentage(clampedVolume);
      currentBoostStatus.value = '${boostFactor.toStringAsFixed(1)}x';
      
      // Enable boost with the calculated factor
      _boostService.setBoostLevel(boostFactor);
      _boostService.enableBoost();
      
      print('⚡ BOOST MODE: ${clampedVolume}% → System:100% + Boost:${boostFactor}x');
    }

    // Update test sound volume if playing
    if (isKnobDragging.value) {
      _previewService.updateVolume(clampedVolume);
    }
  }

  void startKnobDrag() {
    isKnobDragging.value = true;
    
    // Start test sound for feedback
    _previewService.startPreview().then((_) {
      _previewService.updateVolume(currentVolume.value);
    });

    // Haptic feedback
    if (_settingsService.isVibrationEnabled.value) {
      Vibration.vibrate(duration: 20);
    }

    print('🎛️ Knob drag started');
  }

  void endKnobDrag() {
    isKnobDragging.value = false;
    _previewService.startInactivityTimer();
    print('🎛️ Knob drag ended - Current volume: ${currentVolume.value}%');
  }

  void manualPlayTestSound() {
    _previewService.playPreviewAtVolume(currentVolume.value);
    if (_settingsService.isVibrationEnabled.value) {
      Vibration.vibrate(duration: 15);
    }
  }

  bool isBoostActive() {
    return currentVolume.value > 100;
  }

  String getBoostFactorText() {
    if (!isBoostActive()) return 'OFF';
    final factor = _boostService.getBoostFactorForPercentage(currentVolume.value);
    return '${factor.toStringAsFixed(1)}x';
  }

  @override
  void onClose() {
    _previewService.stopPreview();
    _boostService.disableBoost();
    super.onClose();
  }
}