import 'package:get/get.dart';

import 'package:volume_booster_fresh/controllers/booster_controller.dart';
import 'package:volume_booster_fresh/services/audio_boost_service.dart';
import 'package:volume_booster_fresh/services/audio_preview_service.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';

class BoosterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VolumeService());
    Get.lazyPut(() => AudioBoostService());
    Get.lazyPut(() => AudioPreviewService());
    Get.lazyPut(() => BoosterController());
  }
}