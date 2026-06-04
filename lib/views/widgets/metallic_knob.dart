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
  double _currentAngle = 0;
  int _lastNotifiedValue = -1;
  
  @override
  void initState() {
    super.initState();
    _updateAngleFromValue(widget.value);
  }
  
  @override
  void didUpdateWidget(MetallicKnob oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateAngleFromValue(widget.value);
    }
  }
  
  void _updateAngleFromValue(int value) {
    setState(() {
      _currentAngle = -pi * 0.75 + (value / 200) * (pi * 1.5);
    });
  }
  
  void _handlePanUpdate(DragUpdateDetails details, RenderBox box) {
    final center = box.size.center(Offset.zero);
    final position = details.localPosition;
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    
    double angle = atan2(dy, dx);
    const minAngle = -pi * 0.75;
    const maxAngle = pi * 0.75;
    angle = angle.clamp(minAngle, maxAngle);
    
    final value = ((angle - minAngle) / (maxAngle - minAngle) * 200).round();
    final clampedValue = value.clamp(0, 200);
    
    if (clampedValue != widget.value) {
      widget.onChanged(clampedValue);
      
      // Provide haptic feedback on value change
      if (clampedValue != _lastNotifiedValue) {
        _lastNotifiedValue = clampedValue;
        HapticFeedback.selectionClick();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        HapticFeedback.lightImpact();
        widget.onDragStart();
      },
      onPanUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        _handlePanUpdate(details, box);
      },
      onPanEnd: (details) {
        widget.onDragEnd();
      },
      child: CustomPaint(
        size: const Size(280, 280),
        painter: MetallicKnobPainter(angle: _currentAngle, value: widget.value),
      ),
    );
  }
}

class MetallicKnobPainter extends CustomPainter {
  final double angle;
  final int value;
  
  MetallicKnobPainter({required this.angle, required this.value});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Outer metallic ring
    final outerPaint = Paint()
      ..shader = const SweepGradient(
        center: Alignment.center,
        colors: [Color(0xFF444444), Color(0xFF888888), Color(0xFFCCCCCC), Color(0xFF888888), Color(0xFF444444)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outerPaint);
    
    // Inner circle
    final innerRadius = radius - 20;
    final innerPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFFDDDDDD), Color(0xFF999999), Color(0xFF555555)],
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, innerPaint);
    
    // Percentage markers
    final markerPaint = Paint()..color = Colors.white70..strokeWidth = 2;
    final textStyle = TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold);
    
    for (int i = 0; i <= 10; i++) {
      final percentage = i * 20;
      final markerAngle = -pi * 0.75 + (percentage / 200) * (pi * 1.5);
      final startPoint = Offset(
        center.dx + (innerRadius - 8) * cos(markerAngle),
        center.dy + (innerRadius - 8) * sin(markerAngle),
      );
      final endPoint = Offset(
        center.dx + (innerRadius - 18) * cos(markerAngle),
        center.dy + (innerRadius - 18) * sin(markerAngle),
      );
      
      canvas.drawLine(startPoint, endPoint, markerPaint);
      
      // Draw percentage text
      final textRadius = innerRadius - 28;
      final textPoint = Offset(
        center.dx + textRadius * cos(markerAngle),
        center.dy + textRadius * sin(markerAngle),
      );
      
      final textSpan = TextSpan(text: '$percentage%', style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(
        canvas,
        textPoint - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
    
    // Knob indicator with glow effect for boost mode
    final indicatorLength = innerRadius - 15;
    final indicatorPoint = Offset(
      center.dx + indicatorLength * cos(angle),
      center.dy + indicatorLength * sin(angle),
    );
    
    // Glow effect when boost is active
    if (value > 100) {
      final glowPaint = Paint()
        ..color = Colors.green.withOpacity(0.4 + (value - 100) / 100 * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      canvas.drawCircle(indicatorPoint, 14, glowPaint);
    }
    
    // Indicator circle
    final indicatorPaint = Paint()
      ..color = value > 100 ? Colors.green : Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(indicatorPoint, 10, indicatorPaint);
    
    final innerIndicatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(indicatorPoint, 5, innerIndicatorPaint);
    
    // Center cap
    final capPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 22, capPaint);
    
    final capInnerPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 15, capInnerPaint);
  }
  
  @override
  bool shouldRepaint(MetallicKnobPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.value != value;
  }
}

