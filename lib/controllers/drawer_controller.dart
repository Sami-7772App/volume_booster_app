import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  final RxInt selectedIndex = 0.obs;
  
  void navigateTo(int index, BuildContext context) {
    selectedIndex.value = index;
    
    switch (index) {
      case 0: // Home
        Get.toNamed('/volume-settings');
        break;
      case 1: // Volume Settings
        Get.toNamed('/volume-settings');
        break;
      case 2: // Booster
        Get.toNamed('/booster');
        break;
      case 3: // Settings
        Get.toNamed('/settings');
        break;
      case 4: // About
        _showAboutDialog();
        break;
      case 5: // Share
        _shareApp();
        break;
      case 6: // Exit
        _exitApp();
        break;
    }
    
    Navigator.pop(context);
  }
  
  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('About Volume Booster'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 10),
            Text('Boost your device volume up to 200% with crystal clear sound quality.'),
            SizedBox(height: 10),
            Text('© 2024 Volume Booster App'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _shareApp() {
    Get.snackbar(
      'Share App',
      'Share functionality would be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void _exitApp() {
    Get.dialog(
      AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.closeAllSnackbars();
              Future.delayed(const Duration(milliseconds: 100), () {
                // Properly close the app
                SystemNavigator.pop();
              });
            },
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}