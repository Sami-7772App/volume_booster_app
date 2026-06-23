
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_booster_fresh/services/audio_boost_service.dart';
import 'package:volume_booster_fresh/services/audio_preview_service.dart';
import 'package:volume_booster_fresh/services/settings_service.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';
import 'package:volume_booster_fresh/services/audio_focus_service.dart';

class BoosterController extends GetxController {
  final VolumeService _volumeService = Get.find();
  final AudioBoostService _boostService = Get.find();
  final AudioPreviewService _previewService = Get.find();
  final SettingsService _settingsService = Get.find();
  final AudioFocusService _audioFocusService = Get.find();

  final RxInt currentVolume = 50.obs;
  final RxBool isKnobDragging = false.obs;
  final RxString currentBoostStatus = 'OFF'.obs;
  final RxString mediaStatus = '🔇 No media'.obs;

  Timer? _updateTimer;
  bool _isUpdating = false;
  int _pendingVolume = -1;

  @override
  void onInit() {
    super.onInit();
    _loadInitialVolume();
    _listenToMediaStatus();
    _listenToSystemVolume();
  }

  void _loadInitialVolume() {
    currentVolume.value = _volumeService.getMediaVolumePercentage();
    print('🎛️ Initial: ${currentVolume.value}%');
  }

  void _listenToSystemVolume() {
    _volumeService.mediaVolume.listen((volume) {
      if (!isKnobDragging.value && !_isUpdating) {
        final percentage = volume;
        if (percentage != currentVolume.value) {
          currentVolume.value = percentage;
          // Update boost status based on volume
          if (percentage > 100) {
            currentBoostStatus.value = '${(percentage / 100).toStringAsFixed(1)}x';
          } else {
            currentBoostStatus.value = 'OFF';
          }
        }
      }
    });
  }

  void _listenToMediaStatus() {
    _audioFocusService.isMediaPlaying.listen((isPlaying) {
      if (isPlaying) {
        mediaStatus.value = '🎵 Media playing';
        if (_previewService.isPlaying()) {
          _previewService.stopPreview();
        }
      } else {
        mediaStatus.value = '🔇 No media';
      }
    });
  }

  void updateVolume(int newVolume) {
    if (_isUpdating) return;
    
    // Cancel any pending update
    _updateTimer?.cancel();
    
    // Store the pending volume
    _pendingVolume = newVolume;
    
    // Use a short delay to batch rapid updates
    _updateTimer = Timer(const Duration(milliseconds: 16), () {
      if (_pendingVolume != -1 && !_isUpdating) {
        _applyVolumeChange(_pendingVolume);
        _pendingVolume = -1;
      }
    });
  }
  
  void _applyVolumeChange(int newVolume) async {
    if (_isUpdating) return;
    _isUpdating = true;
    
    final clamped = newVolume.clamp(0, 200);
    
    // Check if we're crossing the threshold (100%)
    final wasBoostMode = currentVolume.value > 100;
    final willBeBoostMode = clamped > 100;
    
    // Handle transition from boost to normal mode
    if (wasBoostMode && !willBeBoostMode) {
      // First disable boost
      await _boostService.disableBoost();
      // Small delay to ensure boost is disabled
      await Future.delayed(const Duration(milliseconds: 10));
      // Then set system volume
      _volumeService.setMediaVolume(clamped);
      currentBoostStatus.value = 'OFF';
    } 
    // Handle transition from normal to boost mode
    else if (!wasBoostMode && willBeBoostMode) {
      // Set system to max first
      _volumeService.setMediaVolume(100);
      // Small delay
      await Future.delayed(const Duration(milliseconds: 10));
      // Then apply boost
      _boostService.applyBoost(clamped);
      currentBoostStatus.value = '${(clamped / 100).toStringAsFixed(1)}x';
    }
    // Both in normal mode (≤100)
    else if (!wasBoostMode && !willBeBoostMode) {
      _volumeService.setMediaVolume(clamped);
      currentBoostStatus.value = 'OFF';
    }
    // Both in boost mode (>100)
    else if (wasBoostMode && willBeBoostMode) {
      _volumeService.setMediaVolume(100);
      _boostService.applyBoost(clamped);
      currentBoostStatus.value = '${(clamped / 100).toStringAsFixed(1)}x';
    }
    
    // Update the UI value
    currentVolume.value = clamped;
    
    // Update test sound if dragging
    if (isKnobDragging.value && !_audioFocusService.isMediaPlaying.value) {
      // Calculate preview volume (0.0 to 1.0)
      double previewVol;
      if (clamped <= 100) {
        previewVol = clamped / 100.0;
      } else {
        previewVol = 1.0 + ((clamped - 100) / 100.0);
      }
      _previewService.updateVolumeSmooth(previewVol);
    }
    
    // Haptic feedback for every 5% change
    if (_settingsService.isVibrationEnabled.value && isKnobDragging.value) {
      if (clamped % 5 == 0) {
        Vibration.vibrate(duration: 5);
      }
    }
    
    _isUpdating = false;
    
    print('🎛️ Volume updated: $clamped% (${willBeBoostMode ? 'BOOST' : 'NORMAL'} mode)');
  }

  void startKnobDrag() {
    isKnobDragging.value = true;
    _isUpdating = false;
    _updateTimer?.cancel();
    _pendingVolume = -1;

    if (!_audioFocusService.isMediaPlaying.value) {
      _previewService.playPreviewAtVolume(currentVolume.value);
    }

    if (_settingsService.isVibrationEnabled.value) {
      Vibration.vibrate(duration: 15);
    }
    
    print('🎛️ Knob drag started');
  }

  void endKnobDrag() {
    isKnobDragging.value = false;
    _updateTimer?.cancel();
    _isUpdating = false;
    _pendingVolume = -1;
    
    if (!_audioFocusService.isMediaPlaying.value && _previewService.isPlaying()) {
      _previewService.startInactivityTimer();
    }
    
    print('🎛️ Knob drag ended - Final volume: ${currentVolume.value}%');
  }

  void manualPlayTestSound() {
    if (_audioFocusService.isMediaPlaying.value) {
      Get.snackbar('Cannot Play', 'Media is playing', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange);
      return;
    }
    _previewService.playPreviewAtVolume(currentVolume.value);
  }

  bool isBoostActive() => currentVolume.value > 100;

  String getBoostFactorText() {
    if (!isBoostActive()) return 'OFF';
    return '${(currentVolume.value / 100).toStringAsFixed(1)}x';
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    _previewService.stopPreview();
    _boostService.disableBoost();
    super.onClose();
  }
}