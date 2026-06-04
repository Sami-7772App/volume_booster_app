import 'package:get/get.dart';

import 'package:volume_booster_fresh/controllers/volume_settings_controller.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';

class VolumeSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VolumeService());
    Get.lazyPut(() => VolumeSettingsController());
  }
}
