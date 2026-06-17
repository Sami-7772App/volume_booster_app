
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:volume_booster_fresh/controllers/volume_settings_controller.dart';
import 'package:volume_booster_fresh/services/volume_service.dart';
import 'package:volume_booster_fresh/views/widgets/custom_drawer.dart';

class VolumeSettingsScreen extends StatefulWidget {
  const VolumeSettingsScreen({super.key});

  @override
  State<VolumeSettingsScreen> createState() => _VolumeSettingsScreenState();
}

class _VolumeSettingsScreenState extends State<VolumeSettingsScreen> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
          print('✅ Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('❌ Banner ad failed to load: $error');
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

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
        actions: [
          // Profile/Silent Mode Button
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isPhoneSilent.value
                    ? Icons.volume_off
                    : Icons.volume_up,
                color: controller.isPhoneSilent.value
                    ? Colors.red
                    : Colors.green,
                size: 28,
              ),
              onPressed: () {
                controller.toggleSilentMode();
              },
              tooltip: controller.isPhoneSilent.value
                  ? 'Phone is Silent - Tap to enable sound'
                  : 'Phone is Normal - Tap to enable silent mode',
            ),
          ),
          const SizedBox(width: 8),
        ],
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
              children: [
                const SizedBox(height: 8),

                // Silent Mode Banner
                Obx(
                  () => controller.isPhoneSilent.value
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.volume_off,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '🔇 Phone is in Silent Mode',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller.toggleSilentMode(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'UNMUTE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Banner Ad - Placed at TOP below AppBar
                if (_isAdLoaded && _bannerAd != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 50,
                    child: AdWidget(ad: _bannerAd!),
                  ),

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
                              percentage: volumeService
                                  .getMediaVolumePercentage(),
                              currentValue: volumeService.mediaVolume.value,
                              maxValue: volumeService.maxMediaVolume.value,
                              onChanged: (value) =>
                                  controller.updateMediaVolume(value),
                              onDragStart: controller.onMediaVolumeDragStart,
                              isSilent: controller.isPhoneSilent.value,
                            ),

                            // Ringtone Volume
                            _buildVolumeCard(
                              title: 'Ringtone',
                              icon: Icons.phone_android,
                              percentage: volumeService
                                  .getRingVolumePercentage(),
                              currentValue: volumeService.ringVolume.value,
                              maxValue: volumeService.maxRingVolume.value,
                              onChanged: (value) =>
                                  controller.updateRingVolume(value),
                              onDragStart: controller.onRingVolumeDragStart,
                              isSilent: controller.isPhoneSilent.value,
                            ),

                            // Alarm Volume
                            _buildVolumeCard(
                              title: 'Alarm',
                              icon: Icons.alarm,
                              percentage: volumeService
                                  .getAlarmVolumePercentage(),
                              currentValue: volumeService.alarmVolume.value,
                              maxValue: volumeService.maxAlarmVolume.value,
                              onChanged: (value) =>
                                  controller.updateAlarmVolume(value),
                              onDragStart: controller.onAlarmVolumeDragStart,
                              isSilent: controller.isPhoneSilent.value,
                            ),

                            // Notification Volume
                            _buildVolumeCard(
                              title: 'Notifications',
                              icon: Icons.notifications,
                              percentage: volumeService
                                  .getNotificationVolumePercentage(),
                              currentValue:
                                  volumeService.notificationVolume.value,
                              maxValue:
                                  volumeService.maxNotificationVolume.value,
                              onChanged: (value) =>
                                  controller.updateNotificationVolume(value),
                              onDragStart:
                                  controller.onNotificationVolumeDragStart,
                              isSilent: controller.isPhoneSilent.value,
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
                            debugPrint(
                              'back_button_clicked: from_screen=volume_settings, timestamp=${DateTime.now().millisecondsSinceEpoch}',
                            );
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
    required bool isSilent,
  }) {
    final double sliderValue = currentValue.toDouble().clamp(
      0.0,
      maxValue.toDouble(),
    );

    // If silent mode is active, volume should be 0
    final bool isMuted = isSilent;
    final double displayValue = isMuted ? 0 : sliderValue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMuted
              ? Colors.red.withOpacity(0.3)
              : Colors.grey[800] ?? Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isMuted
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isMuted ? Icons.volume_off : icon,
                  color: isMuted ? Colors.red : Colors.green,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isMuted ? Colors.red : Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isMuted
                      ? Colors.red.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isMuted ? '0%' : '$percentage%',
                  style: TextStyle(
                    color: isMuted ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isMuted ? Icons.volume_off : Icons.volume_down,
                size: 14,
                color: isMuted ? Colors.red : Colors.grey[400],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Slider(
                  value: displayValue,
                  min: 0,
                  max: maxValue.toDouble(),
                  activeColor: isMuted ? Colors.red : Colors.green,
                  inactiveColor: Colors.grey[700],
                  onChanged: isMuted ? null : onChanged,
                  onChangeStart: isMuted ? null : (_) => onDragStart(),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                size: 14,
                color: isMuted ? Colors.red : Colors.grey[400],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
