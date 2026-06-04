import 'package:get/get.dart';

import 'package:volume_booster_fresh/controllers/settings_controller.dart';
import 'package:volume_booster_fresh/services/settings_service.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsService());
    Get.lazyPut(() => SettingsController());
  }
}