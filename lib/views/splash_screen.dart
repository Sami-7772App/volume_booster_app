
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:volume_booster_fresh/routes/app_routes.dart';
import 'package:volume_booster_fresh/services/app_open_ad_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Show splash screen for 4 seconds, then show ad and navigate
    Future.delayed(const Duration(seconds: 4), () {
      _showAdAndNavigate();
    });
  }

  Future<void> _showAdAndNavigate() async {
    try {
      final adService = Get.find<AppOpenAdService>();
      // Load and show the ad
      await adService.loadAndShowAd();
      
      // Wait a moment for ad to be dismissed
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print('Error with app open ad: $e');
    }
    
    // Navigate after ad
    _checkAndNavigate();
  }

  void _checkAndNavigate() {
    final box = GetStorage();
    final hasSeenOnboarding = box.read('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      Get.offAllNamed(AppRoutes.volumeSettings);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            SizedBox(
              width: 150,
              height: 150,
              child: LogoAnimation(),
            ),
            const SizedBox(height: 30),
            // App Name
            const Text(
              'Volume Booster',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            // Tagline
            const Text(
              'Boost Your Sound Up to 200%',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 2,
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widget for the Moving Logo
class LogoAnimation extends StatefulWidget {
  const LogoAnimation({super.key});

  @override
  State<LogoAnimation> createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green, Colors.greenAccent],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.volume_up_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}