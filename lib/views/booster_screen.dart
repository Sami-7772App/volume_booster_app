import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_booster_fresh/controllers/booster_controller.dart';
import 'package:volume_booster_fresh/views/widgets/custom_drawer.dart';
import 'package:volume_booster_fresh/views/widgets/metallic_knob.dart';

class BoosterScreen extends StatefulWidget {
  const BoosterScreen({super.key});

  @override
  State<BoosterScreen> createState() => _BoosterScreenState();
}

class _BoosterScreenState extends State<BoosterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Function to get needle color based on value
  Color _getNeedleColor(int value) {
    if (value <= 100) {
      return Colors.green;
    } else if (value <= 150) {
      // Smooth transition from green to yellow (100-150)
      double progress = (value - 100) / 50; // 0 to 1
      return Color.lerp(Colors.green, Colors.amber, progress)!;
    } else if (value <= 200) {
      // Smooth transition from yellow to red (150-200)
      double progress = (value - 150) / 50; // 0 to 1
      return Color.lerp(Colors.amber, Colors.red, progress)!;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BoosterController>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final knobHeight = screenHeight * 0.42;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Volume Booster'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        // Get current color based on volume
        final needleColor = _getNeedleColor(controller.currentVolume.value);
        final isBoostActive = controller.isBoostActive();

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[900]!, Colors.black],
            ),
          ),
          child: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                // Main content - Expanded to take available space
                Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Knob section
                        SizedBox(
                          height: knobHeight,
                          child: Center(
                            child: Transform.scale(
                              scale: 1.1,
                              child: MetallicKnob(
                                value: controller.currentVolume.value,
                                needleColor: needleColor,
                                onChanged: (value) =>
                                    controller.updateVolume(value),
                                onDragStart: () => controller.startKnobDrag(),
                                onDragEnd: () => controller.endKnobDrag(),
                              ),
                            ),
                          ),
                        ),

                        // Volume info panel
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isBoostActive
                                  ? needleColor.withOpacity(0.5)
                                  : Colors.green.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Dynamic percentage text color only
                              Text(
                                '${controller.currentVolume.value}%',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: isBoostActive
                                      ? needleColor
                                      : Colors.green,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isBoostActive)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: needleColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: needleColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.flash_on,
                                            size: 14,
                                            color: needleColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'BOOST MODE ACTIVE',
                                            style: TextStyle(
                                              color: needleColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Current Volume: ',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Text(
                                        '${controller.currentVolume.value}%',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isBoostActive
                                              ? needleColor
                                              : Colors.white,
                                          fontWeight: isBoostActive
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Current Boost: ',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          controller.getBoostFactorText(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isBoostActive
                                                ? needleColor
                                                : Colors.white54,
                                            fontWeight: isBoostActive
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isBoostActive) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: needleColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: needleColor.withOpacity(0.3),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Text(
                                        '+${controller.currentVolume.value - 100}% Boost',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: needleColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Use the knob to adjust volume. Boost mode allows you to exceed 100% for extra loudness.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Add bottom padding
                        SizedBox(
                          height: 80, // Space for buttons
                        ),
                      ],
                    ),
                  ),
                ),

                // Dual Navigation Buttons - Fixed at bottom
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.2],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: bottomPadding + 12,
                      top: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/volume-settings');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[850],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 52),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'SETTINGS',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Already on Booster Mode'),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 52),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              'BOOSTER',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}