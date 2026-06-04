// lib/views/widgets/volume_slider_item.dart
import 'package:flutter/material.dart';

class VolumeSliderItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final int percentage;
  final int currentVolume;
  final int maxVolume;
  final ValueChanged<double> onChanged;
  
  const VolumeSliderItem({
    super.key,
    required this.title,
    required this.icon,
    required this.percentage,
    required this.currentVolume,
    required this.maxVolume,
    required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.volume_down, size: 20, color: Colors.grey),
              Expanded(
                child: Slider(
                  value: currentVolume.toDouble(),
                  min: 0,
                  max: maxVolume.toDouble(),
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                  onChanged: onChanged,
                ),
              ),
              const Icon(Icons.volume_up, size: 20, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                maxVolume.toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}