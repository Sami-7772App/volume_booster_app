import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_booster_fresh/routes/app_routes.dart';

class DrawerControllerX extends GetxController {
  // URLs
  final String privacyPolicyUrl =
      'https://sites.google.com/view/inverter-town-llc/privacy-policy';
  final String termsOfServiceUrl =
      'https://docs.google.com/document/d/12WTnUBG0hlYkg5fRPIwxP4VnNkUhv_gnC19ulCfgHic/edit';

  // More Apps URL - Play Store developer page
  final String moreAppsUrl =
      'https://play.google.com/store/apps/developer?id=FutureDial+Labs+LLC';

  // Your App's Play Store URL
  final String appPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.yourpackage.name'; // Replace with your actual app package name

  Future<void> navigateTo(int index, BuildContext context) async {
    // Close the drawer first
    Navigator.pop(context);

    switch (index) {
      case 0: // Volume Settings (Home Screen)
        Get.offAllNamed(AppRoutes.volumeSettings);
        break;
      case 1: // FAQ's and Help
        Get.toNamed(AppRoutes.faq);
        break;
      case 2: // More Apps
        await _openMoreApps();
        break;
      case 3: // Share
        await _shareApp();
        break;
      case 4: // Terms of Service
        await _openTermsOfService();
        break;
      case 5: // Privacy Policy
        await _openPrivacyPolicy();
        break;
    }
  }

  /// Opens More Apps (Play Store developer page)
  Future<void> _openMoreApps() async {
    final Uri uri = Uri.parse(moreAppsUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Silent fail
      Get.snackbar(
        'Error',
        'Could not open Play Store',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Opens Privacy Policy directly in Chrome
  Future<void> _openPrivacyPolicy() async {
    final Uri uri = Uri.parse(privacyPolicyUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Silent fail
    }
  }

  /// Opens Terms of Service directly in Chrome
  Future<void> _openTermsOfService() async {
    final Uri uri = Uri.parse(termsOfServiceUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _shareApp() async {
    final String shareText = appPlayStoreUrl;

    try {
      await Share.share(shareText, subject: 'Volume Booster App');
    } catch (e) {
      // Silent fail
      Get.snackbar(
        'Error',
        'Could not share app',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void closeDrawer(BuildContext context) {
    Navigator.pop(context);
  }
}
