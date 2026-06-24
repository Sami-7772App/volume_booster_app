// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:volume_booster_fresh/routes/app_page.dart';
import 'package:volume_booster_fresh/services/app_open_ad_service.dart';

// Services
import 'package:volume_booster_fresh/services/media_volume_service.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';
import 'package:volume_booster_fresh/services/audio_boost_service.dart';
import 'package:volume_booster_fresh/services/audio_preview_service.dart';
import 'package:volume_booster_fresh/services/permission_service.dart';
import 'package:volume_booster_fresh/services/settings_service.dart';
import 'package:volume_booster_fresh/services/system_tone_service.dart';
import 'package:volume_booster_fresh/services/equalizer_service.dart';
import 'package:volume_booster_fresh/services/audio_focus_service.dart';

// Controllers
import 'package:volume_booster_fresh/controllers/volume_settings_controller.dart';
import 'package:volume_booster_fresh/controllers/booster_controller.dart';
import 'package:volume_booster_fresh/controllers/settings_controller.dart';
import 'package:volume_booster_fresh/controllers/drawer_controller.dart';

// Routes
import 'package:volume_booster_fresh/config/env_config.dart';
import 'package:volume_booster_fresh/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  await GetStorage.init();

  // Initialize services
  final permissionService = PermissionService();
  await permissionService.init();
  Get.put(permissionService);

  final settingsService = SettingsService();
  await settingsService.init();
  Get.put(settingsService);

  final systemToneService = SystemToneService();
  await systemToneService.init();
  Get.put(systemToneService);

  final audioFocusService = AudioFocusService();
  await audioFocusService.init();
  Get.put(audioFocusService);

  final equalizerService = EqualizerService();
  await equalizerService.init();
  Get.put(equalizerService);

  final mediaVolumeService = MediaVolumeService();
  await mediaVolumeService.init();
  Get.put(mediaVolumeService);

  final volumeService = VolumeService();
  await volumeService.init();
  Get.put(volumeService);

  final audioBoostService = AudioBoostService();
  await audioBoostService.init();
  Get.put(audioBoostService);

  final audioPreviewService = AudioPreviewService();
  await audioPreviewService.init();
  Get.put(audioPreviewService);

  // Initialize App Open Ad Service (ads disabled)
  final appOpenAdService = AppOpenAdService();
  await appOpenAdService.init();
  Get.put(appOpenAdService);

  // Initialize controllers
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
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fade,
    );
  }
}
