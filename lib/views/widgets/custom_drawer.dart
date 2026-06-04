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
            colors: [
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
                gradient: LinearGradient(
                  colors: [Colors.green.shade800, Colors.green.shade600],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.volume_up,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Volume Booster',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Boost up to 200%',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              index: 0,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.volume_down,
              title: 'Volume Settings',
              index: 1,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.bolt,
              title: 'Booster',
              index: 2,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              index: 3,
              controller: controller,
            ),
            const Divider(color: Colors.grey),
            _buildDrawerItem(
              icon: Icons.info,
              title: 'About Us',
              index: 4,
              controller: controller,
            ),
            _buildDrawerItem(
              icon: Icons.share,
              title: 'Share App',
              index: 5,
              controller: controller,
            ),
            const Divider(color: Colors.grey),
            _buildDrawerItem(
              icon: Icons.exit_to_app,
              title: 'Exit',
              index: 6,
              controller: controller,
              color: Colors.red,
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
      title: Text(title, style: TextStyle(color: color ?? Colors.white)),
      onTap: () => controller.navigateTo(index, Get.context!),
    );
  }
}