import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_booster_fresh/config/env_config.dart';
import 'package:volume_booster_fresh/routes/app_routes.dart';

class DrawerControllerX extends GetxController {
  final String appPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.yourpackage.name';

  Future<void> navigateTo(int index, BuildContext context) async {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.volumeSettings);
        break;
      case 1:
        Get.toNamed(AppRoutes.faq);
        break;
      case 2:
        await _openMoreApps();
        break;
      case 3:
        await _shareApp();
        break;
      case 4:
        await _openTermsOfService();
        break;
      case 5:
        await _openPrivacyPolicy();
        break;
    }
  }

  Future<void> _openMoreApps() async {
    await _openUrl(
      EnvConfig.moreAppsUrl,
      errorMessage: 'Could not open app store',
    );
  }

  Future<void> _openPrivacyPolicy() async {
    await _openUrl(EnvConfig.privacyPolicyUrl);
  }

  Future<void> _openTermsOfService() async {
    await _openUrl(EnvConfig.termsOfServiceUrl);
  }

  Future<void> _openUrl(String url, {String errorMessage = 'Could not open link'}) async {
    if (url.isEmpty) {
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _shareApp() async {
    try {
      await Share.share(appPlayStoreUrl, subject: 'Volume Booster App');
    } catch (_) {
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
