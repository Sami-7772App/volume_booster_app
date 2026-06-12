
// ignore_for_file: unused_field

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MetallicKnob extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;

  const MetallicKnob({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onDragStart,
    required this.onDragEnd,
  });

  @override
  State<MetallicKnob> createState() => _MetallicKnobState();
}

class _MetallicKnobState extends State<MetallicKnob> {
  bool _isDragging = false;

  // Knob configuration definitions matching the picture
  static const double _startAngleDegrees = 145.0;
  static const double _endAngleDegrees =
      395.0; // 395 means 35 degrees on next loop
  static const double _totalSweepDegrees =
      _endAngleDegrees - _startAngleDegrees; // 250°

  double _degreesToRadians(double degrees) => degrees * pi / 180;
  double _radiansToDegrees(double radians) => radians * 180 / pi;

  // Converts value (0-200) to radians for the rotation and painter
  double _getValueAngleRadians(int value) {
    final double pct = value / 200.0;
    final double targetDegrees =
        _startAngleDegrees + (pct * _totalSweepDegrees);
    return _degreesToRadians(targetDegrees);
  }

  void _handlePanUpdate(DragUpdateDetails details, RenderBox box) {
    final center = box.size.center(Offset.zero);
    final position = details.localPosition;
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;

    // Get angle in radians (-PI to PI)
    double angleRad = atan2(dy, dx);
    double angleDeg = _radiansToDegrees(angleRad);

    // Normalize angle to a 0-360 range starting from 0 (Right axis)
    if (angleDeg < 0) angleDeg += 360;

    // Adjust for the gap at the bottom loop
    if (angleDeg < _startAngleDegrees && angleDeg > (_endAngleDegrees - 360)) {
      // Finger is in the bottom dead-zone gap
      final midGap = (_startAngleDegrees + (_endAngleDegrees - 360)) / 2;
      angleDeg = (angleDeg > midGap) ? _startAngleDegrees : _endAngleDegrees;
    } else if (angleDeg <= (_endAngleDegrees - 360)) {
      angleDeg += 360;
    }

    // Map the calculated angle to our 0-200 range value
    final double relativeDeg = angleDeg - _startAngleDegrees;
    final double pct = (relativeDeg / _totalSweepDegrees).clamp(0.0, 1.0);
    final int calculatedValue = (pct * 200).round();

    if (calculatedValue != widget.value) {
      widget.onChanged(calculatedValue);
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Current rotation of the knob indicator line
    final double knobRotation = _getValueAngleRadians(widget.value);

    return Listener(
      onPointerDown: (_) {
        _isDragging = true;
        widget.onDragStart();
      },
      onPointerUp: (_) {
        _isDragging = false;
        widget.onDragEnd();
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          final box = context.findRenderObject() as RenderBox;
          _handlePanUpdate(details, box);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Scale ticks and Labels Painter
            SizedBox(
              width: 340,
              height: 340,
              child: CustomPaint(
                painter: ScalePainter(
                  value: widget.value,
                  startAngleDeg: _startAngleDegrees,
                  sweepDegrees: _totalSweepDegrees,
                ),
              ),
            ),

            // 2. Metallic Knob Base with Image
            Transform.rotate(
              angle: knobRotation,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 16,
                      spreadRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/metalic_knob.png', // Corrected path
                    width: 210,
                    height: 210,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to gradient if image not found
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            center: Alignment.center,
                            colors: const [
                              Color(0xFFE8ECEF),
                              Color(0xFF8A95A5),
                              Color(0xFF2D3238),
                              Color(0xFF5A6575),
                              Color(0xFF1C2024),
                              Color(0xFF9AA3B0),
                              Color(0xFFE8ECEF),
                            ],
                            stops: const [
                              0.0,
                              0.15,
                              0.35,
                              0.5,
                              0.65,
                              0.85,
                              1.0,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 3. Center cap for realistic knob look
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade600,
                    Colors.grey.shade800,
                  ],
                  stops: const [0.2, 0.6, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade700,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScalePainter extends CustomPainter {
  final int value;
  final double startAngleDeg;
  final double sweepDegrees;

  ScalePainter({
    required this.value,
    required this.startAngleDeg,
    required this.sweepDegrees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Total number of smallest increments
    const int totalTicks =
        80; // 4 ticks per 10 units interval (every 2.5 units)

    for (int i = 0; i <= totalTicks; i++) {
      // Calculate active numeric value equivalent for this specific tick mark
      final double calculatedValue = (i / totalTicks) * 200;
      final bool isActive = calculatedValue <= value;

      // Calculate placement rotation angle
      final double currentDeg = startAngleDeg + (i / totalTicks * sweepDegrees);
      final double rad = currentDeg * pi / 180;

      // Distinguish major, medium and fine tick intervals
      final bool isMajor = i % 10 == 0; // 0, 25, 50... step sizes
      final bool isMid = i % 5 == 0 && !isMajor;

      double tickLength = isMajor ? 16.0 : (isMid ? 11.0 : 7.0);
      double strokeWidth = isMajor ? 3.0 : (isMid ? 2.0 : 1.2);

      // Color tier logic according to image mapping
      Color tickColor;
      if (calculatedValue <= 100) {
        tickColor = isActive
            ? const Color(0xFF39FF14)
            : Colors.green.withOpacity(0.25); // Neon green
      } else if (calculatedValue <= 150) {
        tickColor = isActive
            ? const Color(0xFFFF9F00)
            : Colors.orange.withOpacity(0.25); // Alert orange
      } else {
        tickColor = isActive
            ? const Color(0xFFFF3B30)
            : Colors.red.withOpacity(0.25); // High danger red
      }

      final tickPaint = Paint()
        ..color = tickColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      final startPoint = Offset(
        center.dx + (radius - tickLength) * cos(rad),
        center.dy + (radius - tickLength) * sin(rad),
      );
      final endPoint = Offset(
        center.dx + radius * cos(rad),
        center.dy + radius * sin(rad),
      );

      canvas.drawLine(startPoint, endPoint, tickPaint);

      // Render Text Strings alongside Major labels (0, 25, 50, 75...)
      if (isMajor) {
        final int displayValue = calculatedValue.round();

        // Match specific styling colors from layout image
        Color textColor = Colors.grey.shade400;
        if (displayValue == value) {
          textColor = Colors.white;
        } else if (displayValue == 200) {
          textColor =
              Colors.white; // Explicit white accent highlight on 200 label
        }

        final textStyle = TextStyle(
          color: textColor,
          fontSize: displayValue == 200 ? 15 : 13,
          fontWeight: displayValue == 200 ? FontWeight.w900 : FontWeight.w500,
          fontFamily: 'SF Pro Display',
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        );

        final textSpan = TextSpan(text: '$displayValue', style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        // Push layout padding numbers slightly outward from line edges
        final double labelRadius = radius + 20;
        final labelPosition = Offset(
          center.dx + labelRadius * cos(rad) - (textPainter.width / 2),
          center.dy + labelRadius * sin(rad) - (textPainter.height / 2),
        );

        textPainter.paint(canvas, labelPosition);
      }
    }
  }

  @override
  bool shouldRepaint(ScalePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
