
// routes/app_page.dart
import 'package:get/get.dart';
import 'package:volume_booster_fresh/bindings/booster_binding.dart';
import 'package:volume_booster_fresh/bindings/settings_binding.dart';
import 'package:volume_booster_fresh/bindings/volume_settings_binding.dart';
import 'package:volume_booster_fresh/routes/app_routes.dart';
import 'package:volume_booster_fresh/views/booster_screen.dart';
import 'package:volume_booster_fresh/views/settings_screen.dart';
import 'package:volume_booster_fresh/views/volume_settings_screen.dart';
import 'package:volume_booster_fresh/views/help_screen.dart'; // FAQ screen
import 'package:volume_booster_fresh/views/splash_screen.dart'; // Import Splash Screen

class AppPages {
  static final pages = [
    // Add Splash Screen as the first page
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    
    GetPage(
      name: AppRoutes.volumeSettings,
      page: () => const VolumeSettingsScreen(),
      binding: VolumeSettingsBinding(),
      transition: Transition.fade,
    ),
    
    GetPage(
      name: AppRoutes.booster,
      page: () => const BoosterScreen(),
      binding: BoosterBinding(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    
    GetPage(
      name: AppRoutes.faq,
      page: () => const HelpScreen(), // Your FAQ screen
      transition: Transition.rightToLeft,
    ),
  ];
}