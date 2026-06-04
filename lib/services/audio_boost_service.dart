


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