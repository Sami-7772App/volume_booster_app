import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_booster_fresh/controllers/volume_settings_controller.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';
import 'package:volume_booster_fresh/views/widgets/custom_drawer.dart';

class VolumeSettingsScreen extends StatelessWidget {
  const VolumeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VolumeSettingsController>();
    final volumeService = Get.find<VolumeService>();

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Volume Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 4),

                // Volume Cards Section
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Media Volume
                            _buildVolumeCard(
                              title: 'Media',
                              icon: Icons.music_note,
                              percentage: volumeService.getMediaVolumePercentage(),
                              currentValue: volumeService.mediaVolume.value,
                              maxValue: volumeService.maxMediaVolume.value,
                              onChanged: (value) =>
                                  controller.updateMediaVolume(value),
                              onDragStart: controller.onMediaVolumeDragStart,
                            ),

                            // Ringtone Volume
                            _buildVolumeCard(
                              title: 'Ringtone',
                              icon: Icons.phone_android,
                              percentage: volumeService.getRingVolumePercentage(),
                              currentValue: volumeService.ringVolume.value,
                              maxValue: volumeService.maxRingVolume.value,
                              onChanged: (value) =>
                                  controller.updateRingVolume(value),
                              onDragStart: controller.onRingVolumeDragStart,
                            ),

                            // Alarm Volume
                            _buildVolumeCard(
                              title: 'Alarm',
                              icon: Icons.alarm,
                              percentage: volumeService.getAlarmVolumePercentage(),
                              currentValue: volumeService.alarmVolume.value,
                              maxValue: volumeService.maxAlarmVolume.value,
                              onChanged: (value) =>
                                  controller.updateAlarmVolume(value),
                              onDragStart: controller.onAlarmVolumeDragStart,
                            ),

                            // Notification Volume
                            _buildVolumeCard(
                              title: 'Notifications',
                              icon: Icons.notifications,
                              percentage: volumeService
                                  .getNotificationVolumePercentage(),
                              currentValue: volumeService.notificationVolume.value,
                              maxValue: volumeService.maxNotificationVolume.value,
                              onChanged: (value) =>
                                  controller.updateNotificationVolume(value),
                              onDragStart: controller.onNotificationVolumeDragStart,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Dual Navigation Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back, size: 18),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'BACK',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.navigateToBooster,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.flash_on, size: 18),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'BOOSTER',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeCard({
    required String title,
    required IconData icon,
    required int percentage,
    required int currentValue,
    required int maxValue,
    required ValueChanged<double> onChanged,
    required VoidCallback onDragStart,
  }) {
    // Ensure slider value is within bounds
    final double sliderValue = currentValue.toDouble().clamp(0.0, maxValue.toDouble());
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[800] ?? Colors.grey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row with Icon, Title, and Percentage
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.green, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Slider Row with Volume Icons
          Row(
            children: [
              Icon(Icons.volume_down, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Expanded(
                child: Slider(
                  value: sliderValue,
                  min: 0,
                  max: maxValue.toDouble(),
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey[700],
                  onChanged: onChanged,
                  onChangeStart: (_) => onDragStart(),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.volume_up, size: 14, color: Colors.grey[400]),
            ],
          ),
        ],
      ),
    );
  }
}