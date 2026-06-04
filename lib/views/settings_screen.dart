import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_booster_fresh/controllers/settings_controller.dart';  // Add this line

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Colors.black],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Appearance',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  Obx(() => SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Use dark theme throughout the app'),
                    value: controller.isDarkMode,
                    onChanged: controller.toggleDarkMode,
                    secondary: const Icon(Icons.dark_mode, color: Colors.green),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Audio & Feedback',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  Obx(() => SwitchListTile(
                    title: const Text('Vibration'),
                    subtitle: const Text('Enable haptic feedback'),
                    value: controller.isVibrationEnabled,
                    onChanged: controller.toggleVibration,
                    secondary: const Icon(Icons.vibration, color: Colors.green),
                  )),
                  Obx(() => SwitchListTile(
                    title: const Text('Sound Effects'),
                    subtitle: const Text('Enable sound effects'),
                    value: controller.isSoundEffectsEnabled,
                    onChanged: controller.toggleSoundEffects,
                    secondary: const Icon(Icons.audiotrack, color: Colors.green),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Reset',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.restore, color: Colors.orange),
                    title: const Text('Reset All Settings'),
                    subtitle: const Text('Restore all settings to default values'),
                    onTap: controller.resetSettings,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}