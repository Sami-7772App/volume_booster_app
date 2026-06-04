
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Services
import 'package:volume_booster_fresh/services/media_volume_service.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';
import 'package:volume_booster_fresh/services/audio_boost_service.dart';
import 'package:volume_booster_fresh/services/audio_preview_service.dart';
import 'package:volume_booster_fresh/services/permission_service.dart';
import 'package:volume_booster_fresh/services/settings_service.dart';
import 'package:volume_booster_fresh/services/system_tone_service.dart';

// Controllers
import 'package:volume_booster_fresh/controllers/volume_settings_controller.dart';
import 'package:volume_booster_fresh/controllers/booster_controller.dart';
import 'package:volume_booster_fresh/controllers/settings_controller.dart';
import 'package:volume_booster_fresh/controllers/drawer_controller.dart';

// Routes
import 'package:volume_booster_fresh/routes/app_routes.dart';
import 'package:volume_booster_fresh/routes/app_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize services in correct order
  final permissionService = PermissionService();
  await permissionService.init();
  Get.put(permissionService);

  final settingsService = SettingsService();
  await settingsService.init();
  Get.put(settingsService);

  // 1. Initialize MediaVolumeService FIRST (controls YouTube volume)
  final mediaVolumeService = MediaVolumeService();
  await mediaVolumeService.init();
  Get.put(mediaVolumeService);

  // 2. Initialize VolumeService (depends on MediaVolumeService)
  final volumeService = VolumeService();
  await volumeService.init();
  Get.put(volumeService);

  // 3. Initialize AudioBoostService
  final audioBoostService = AudioBoostService();
  await audioBoostService.init();
  Get.put(audioBoostService);

  // 4. Initialize AudioPreviewService
  final audioPreviewService = AudioPreviewService();
  await audioPreviewService.init();
  Get.put(audioPreviewService);

  // 5. Initialize SystemToneService
  final systemToneService = SystemToneService();
  await systemToneService.init();
  Get.put(systemToneService);

  // Initialize all controllers
  Get.put(VolumeSettingsController());
  Get.put(BoosterController());
  Get.put(SettingsController());
  Get.put(DrawerControllerX());

  runApp(const VolumeBoosterApp());
}

class VolumeBoosterApp extends StatelessWidget {
  const VolumeBoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = Get.find<SettingsService>();

    return GetMaterialApp(
      title: 'Volume Booster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: Colors.grey[900],
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      themeMode: settingsService.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: AppRoutes.volumeSettings,
      getPages: AppPages.pages,
      defaultTransition: Transition.fade,
    );
  }
}
