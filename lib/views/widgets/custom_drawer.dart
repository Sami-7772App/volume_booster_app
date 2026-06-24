import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_booster_fresh/controllers/drawer_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DrawerControllerX());

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 24,
                16,
                20,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                gradient: LinearGradient(
                  colors: [Colors.green.shade800, Colors.green.shade600],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.volume_up, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Volume Control Launcher',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Boost up to 200%',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.ring_volume,
              title: 'Volume Settings',
              index: 0,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.help_outline,
              title: "FAQ's and Help",
              index: 1,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.apps,
              title: 'More Apps',
              index: 2,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.share,
              title: 'Share',
              index: 3,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.description,
              title: 'Terms of Service',
              index: 4,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              index: 5,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    required DrawerControllerX controller,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.green),
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.white, fontSize: 16),
      ),
      onTap: () => controller.navigateTo(index, Get.context!),
    );
  }
}





