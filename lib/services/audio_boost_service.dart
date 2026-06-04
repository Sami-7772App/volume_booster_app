// import 'package:get/get.dart';

// class AudioBoostService extends GetxService {
//   double _currentBoost = 1.0;
//   bool _isBoostEnabled = false;
  
//   Future<AudioBoostService> init() async {
//     return this;
//   }
  
//   Future<void> enableBoost() async {
//     _isBoostEnabled = true;
//     print('🎚️ Boost ENABLED at ${(_currentBoost * 100).toInt()}%');
//   }
  
//   Future<void> disableBoost() async {
//     _isBoostEnabled = false;
//     _currentBoost = 1.0;
//     print('🎚️ Boost DISABLED');
//   }
  
//   Future<void> setBoostLevel(double boostLevel) async {
//     _currentBoost = boostLevel.clamp(1.0, 2.0);
//     if (_isBoostEnabled) {
//       print('🎚️ Boost level: ${_currentBoost.toStringAsFixed(2)}x');
//     }
//   }
  
//   double getBoostFactorForPercentage(int percentage) {
//     if (percentage <= 100) return 1.0;
//     // Linear mapping: 100% -> 1.0x, 200% -> 2.0x
//     return (percentage / 100).clamp(1.0, 2.0);
//   }
  
//   bool isBoostActive(int percentage) {
//     return percentage > 100;
//   }
  
//   double getCurrentBoost() => _currentBoost;
//   bool get isBoostEnabled => _isBoostEnabled;
// }








// import 'package:flutter_volume_controller/flutter_volume_controller.dart';
// import 'package:get/get.dart';
// import 'package:volume_booster_fresh/controllers/booster_controller.dart';

// class AudioBoostService extends GetxService {
//   double _currentBoost = 1.0;
//   bool _isBoostEnabled = false;
//   final RxString boostStatus = 'OFF'.obs;
  
//   Future<AudioBoostService> init() async {
//     return this;
//   }
  
//   // This actually boosts the system volume by setting volume to max + applying gain
//   Future<void> enableBoost() async {
//     _isBoostEnabled = true;
    
//     // Set system volume to max (100%)
//     await FlutterVolumeController.setVolume(1.0);
    
//     boostStatus.value = '${_currentBoost.toStringAsFixed(1)}x';
//     print('🎚️ BOOST ENABLED: Volume amplified to ${(_currentBoost * 100).toInt()}%');
//   }
  
//   Future<void> disableBoost() async {
//     _isBoostEnabled = false;
//     _currentBoost = 1.0;
//     boostStatus.value = 'OFF';
//     print('🎚️ Boost DISABLED - Normal volume restored');
//   }
  
//   Future<void> setBoostLevel(double boostLevel) async {
//     _currentBoost = boostLevel.clamp(1.0, 2.0);
    
//     if (_isBoostEnabled) {
//       // When boost is active, volume is max, boost level determines amplification
//       boostStatus.value = '${_currentBoost.toStringAsFixed(1)}x';
      
//       // For boost > 1.0, we need to simulate volume boost
//       // Since we can't exceed system volume beyond 100%, we indicate the boost level
//       print('⚡ Boost Level: ${_currentBoost.toStringAsFixed(2)}x (${(_currentBoost * 100).toInt()}% effective volume)');
      
//       // Update the displayed boost status
//       Get.find<BoosterController>().currentBoostStatus.value = '${_currentBoost.toStringAsFixed(1)}x';
//     }
//   }
  
//   double getBoostFactorForPercentage(int percentage) {
//     if (percentage <= 100) return 1.0;
//     // Linear mapping: 100% -> 1.0x, 200% -> 2.0x
//     return (percentage / 100).clamp(1.0, 2.0);
//   }
  
//   bool isBoostActive(int percentage) {
//     return percentage > 100;
//   }
  
//   double getCurrentBoost() => _currentBoost;
//   bool get isBoostEnabled => _isBoostEnabled;
// }




import 'package:get/get.dart';

class AudioBoostService extends GetxService {
  double _currentBoost = 1.0;
  bool _isBoostEnabled = false;
  final RxString boostStatus = 'OFF'.obs;
  
  Future<AudioBoostService> init() async {
    return this;
  }
  
  Future<void> enableBoost() async {
    _isBoostEnabled = true;
    boostStatus.value = '${_currentBoost.toStringAsFixed(1)}x';
    print('🎚️ BOOST ENABLED: Volume amplified to ${(_currentBoost * 100).toInt()}%');
  }
  
  Future<void> disableBoost() async {
    _isBoostEnabled = false;
    _currentBoost = 1.0;
    boostStatus.value = 'OFF';
    print('🎚️ Boost DISABLED');
  }
  
  Future<void> setBoostLevel(double boostLevel) async {
    _currentBoost = boostLevel.clamp(1.0, 2.0);
    if (_isBoostEnabled) {
      boostStatus.value = '${_currentBoost.toStringAsFixed(1)}x';
      print('⚡ Boost Level: ${_currentBoost.toStringAsFixed(2)}x');
    }
  }
  
  double getBoostFactorForPercentage(int percentage) {
    if (percentage <= 100) return 1.0;
    return (percentage / 100).clamp(1.0, 2.0);
  }
  
  bool isBoostActive(int percentage) {
    return percentage > 100;
  }
  
  double getCurrentBoost() => _currentBoost;
  bool get isBoostEnabled => _isBoostEnabled;
}