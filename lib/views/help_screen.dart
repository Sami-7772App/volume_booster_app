import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volume_booster_fresh/views/widgets/custom_drawer.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Colors.black],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.help_center, size: 60, color: Colors.green),
                  const SizedBox(height: 10),
                  Text(
                    'Help Center',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Frequently Asked Questions',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            // FAQ List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFaqItem(
                    question: 'How do you use Volume Control Launcher?',
                    answer:
                        'Simply open the app and use the volume slider to adjust your device volume. For booster mode, rotate the metallic knob past 100% to activate enhanced loudness.',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqItem(
                    question: 'Why does my homescreen look different?',
                    answer:
                        'Volume Booster does not change your home screen. If your home screen looks different, you may have accidentally changed your launcher settings.',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqItem(
                    question: 'How do I reset my home screen?',
                    answer:
                        'Go to your device Settings > Apps > Default Apps > Home App, then select your preferred launcher.',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqItem(
                    question: 'Where are my apps?',
                    answer:
                        'All your apps are still on your device. You can access them from your app drawer or home screen.',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqItem(
                    question: 'Why am I seeing ads?',
                    answer:
                        'We show ads to keep the app free for everyone. You can remove ads by upgrading to the premium version.',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqItem(
                    question: 'How do I uninstall?',
                    answer:
                        'Go to your device Settings > Apps > Volume Booster > Uninstall. Or long press the app icon and select Uninstall.',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqItem(
                    question: 'How do I remove new apps from my home screen?',
                    answer:
                        'Volume Booster does not add apps to your home screen. Any new apps appear because of your device settings.',
                  ),
                ],
              ),
            ),

            // Contact Support Button
            Padding(
              padding: const EdgeInsets.all(50),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showContactDialog(context);
                },
                icon: const Icon(Icons.email),
                label: const Text('Contact Support'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.question_mark, color: Colors.green, size: 18),
      ),
      title: Text(
        question,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.grey[900]?.withOpacity(0.3),
      collapsedBackgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800] ?? Colors.grey, width: 0.5),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800] ?? Colors.grey, width: 0.5),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.support_agent, color: Colors.green),
            SizedBox(width: 10),
            Text('Contact Support', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'For support inquiries, please email us at:',
              style: GoogleFonts.poppins(color: Colors.grey[400]),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: Colors.green, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'support@volumebooster.com',
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'We typically respond within 24-48 hours.',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Add email intent here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }
}
