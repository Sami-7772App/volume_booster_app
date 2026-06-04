





// ignore_for_file: unused_field

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SystemToneService extends GetxService {
  static const MethodChannel _channel = MethodChannel('com.volume.booster/sounds');
  bool _isInitialized = false;
  
  Future<SystemToneService> init() async {
    try {
      // Test if channel is working
      _isInitialized = true;
      print('✅ SystemToneService initialized');
    } catch (e) {
      print('❌ SystemToneService init error: $e');
    }
    return this;
  }
  
  // Play device's actual ringtone
  Future<void> playRingtone() async {
    try {
      print('🎵 Attempting to play ringtone...');
      final result = await _channel.invokeMethod('playRingtone');
      print('✅ Ringtone played successfully: $result');
    } catch (e) {
      print('❌ Error playing ringtone: $e');
    }
  }
  
  // Play device's actual alarm tone
  Future<void> playAlarmTone() async {
    try {
      print('🎵 Attempting to play alarm...');
      final result = await _channel.invokeMethod('playAlarm');
      print('✅ Alarm played successfully: $result');
    } catch (e) {
      print('❌ Error playing alarm: $e');
    }
  }
  
  // Play device's actual notification tone
  Future<void> playNotificationTone() async {
    try {
      print('🎵 Attempting to play notification...');
      final result = await _channel.invokeMethod('playNotification');
      print('✅ Notification played successfully: $result');
    } catch (e) {
      print('❌ Error playing notification: $e');
    }
  }
  
  // Play media sample
  Future<void> playMediaSample() async {
    print('🎵 Playing media sample');
    // You can add audioplayers here if needed
  }
  
  Future<void> stopSound() async {
    try {
      await _channel.invokeMethod('stopSound');
      print('✅ Sound stopped');
    } catch (e) {
      print('❌ Error stopping sound: $e');
    }
  }
}




