// // ignore_for_file: unused_field

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class MetallicKnob extends StatefulWidget {
//   final int value;
//   final ValueChanged<int> onChanged;
//   final VoidCallback onDragStart;
//   final VoidCallback onDragEnd;

//   const MetallicKnob({
//     super.key,
//     required this.value,
//     required this.onChanged,
//     required this.onDragStart,
//     required this.onDragEnd,
//   });

//   @override
//   State<MetallicKnob> createState() => _MetallicKnobState();
// }

// class _MetallicKnobState extends State<MetallicKnob> {
//   bool _isDragging = false;
//   double _currentAngle = 0;

//   // Knob configuration definitions matching the picture
//   static const double _startAngleDegrees = 145.0;
//   static const double _endAngleDegrees = 395.0;
//   static const double _totalSweepDegrees =
//       _endAngleDegrees - _startAngleDegrees;

//   double _degreesToRadians(double degrees) => degrees * pi / 180;
//   double _radiansToDegrees(double radians) => radians * 180 / pi;

//   // Converts value (0-200) to radians for the rotation
//   double _getValueAngleRadians(int value) {
//     final double pct = value / 200.0;
//     final double targetDegrees =
//         _startAngleDegrees + (pct * _totalSweepDegrees);
//     return _degreesToRadians(targetDegrees);
//   }

//   // Converts angle to value (0-200)
//   int _angleToValue(double angleDeg) {
//     // Normalize angle
//     double normalizedAngle = angleDeg;
//     if (normalizedAngle < _startAngleDegrees &&
//         normalizedAngle > (_endAngleDegrees - 360)) {
//       final midGap = (_startAngleDegrees + (_endAngleDegrees - 360)) / 2;
//       normalizedAngle = (normalizedAngle > midGap)
//           ? _startAngleDegrees
//           : _endAngleDegrees;
//     } else if (normalizedAngle <= (_endAngleDegrees - 360)) {
//       normalizedAngle += 360;
//     }

//     final double relativeDeg = normalizedAngle - _startAngleDegrees;
//     final double pct = (relativeDeg / _totalSweepDegrees).clamp(0.0, 1.0);
//     return (pct * 200).round();
//   }

//   void _handlePanStart(DragStartDetails details) {
//     setState(() {
//       _isDragging = true;
//     });
//     widget.onDragStart();
//     HapticFeedback.lightImpact();
//   }

//   void _handlePanUpdate(DragUpdateDetails details, RenderBox box) {
//     final center = box.size.center(Offset.zero);
//     final position = details.localPosition;
//     final dx = position.dx - center.dx;
//     final dy = position.dy - center.dy;

//     // Get angle in radians (-PI to PI)
//     double angleRad = atan2(dy, dx);
//     double angleDeg = _radiansToDegrees(angleRad);

//     // Normalize angle to 0-360 rang/*e
//     if (angleDeg < 0) angleDeg += 360;

//     // Update current angle for smooth rotation feedback
//     setState(() {
//       _currentAngle = angleDeg;
//     });

//     // Convert angle to value
//     final int calculatedValue = _angleToValue(angleDeg);

//     if (calculatedValue != widget.value) {
//       widget.onChanged(calculatedValue);
//       HapticFeedback.selectionClick();
//     }
//   }

//   void _handlePanEnd(DragEndDetails details) {
//     setState(() {
//       _isDragging = false;
//       _currentAngle = _getValueAngleRadians(widget.value) * 180 / pi;
//     });
//     widget.onDragEnd();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get current rotation angle based on value or gesture
//     final double knobRotation = _isDragging
//         ? _degreesToRadians(_currentAngle)
//         : _getValueAngleRadians(widget.value);

//     // Calculate indicator rotation - the line should point outward from center
//     // The indicator is drawn at 0 degrees (top), so we rotate it with the knob
//     final double indicatorRotation = knobRotation;

//     return GestureDetector(
//       onPanStart: _handlePanStart,
//       onPanUpdate: (details) {
//         final box = context.findRenderObject() as RenderBox;
//         _handlePanUpdate(details, box);
//       },
//       onPanEnd: _handlePanEnd,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Scale ticks and Labels Painter
//           SizedBox(
//             width: 340,
//             height: 340,
//             child: CustomPaint(
//               painter: ScalePainter(
//                 value: widget.value,
//                 startAngleDeg: _startAngleDegrees,
//                 sweepDegrees: _totalSweepDegrees,
//               ),
//             ),
//           ),

//           // Metallic Knob Base with Image (rotates with gesture)
//           Transform.rotate(
//             angle: knobRotation,
//             child: Container(
//               width: 210,
//               height: 210,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.6),
//                     blurRadius: 16,
//                     spreadRadius: 4,
//                     offset: const Offset(0, 4),
//                   ),
//                   if (_isDragging)
//                     BoxShadow(
//                       color: Colors.white.withOpacity(0.3),
//                       blurRadius: 20,
//                       spreadRadius: 8,
//                     ),
//                 ],
//               ),
//               child: ClipOval(
//                 child: Image.asset(
//                   'assets/images/metalic_knob.png',
//                   width: 210,
//                   height: 210,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),

//           // Control indicator - shows current position (rotates with knob)
//           Transform.rotate(
//             angle: indicatorRotation,
//             child: Container(
//               width: 210,
//               height: 210,
//               child: CustomPaint(
//                 painter: KnobIndicatorPainter(isDragging: _isDragging),
//               ),
//             ),
//           ),

//           // Optional: Show current value in center during drag
//           if (_isDragging)
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.black.withOpacity(0.8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.5),
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Text(
//                   '${widget.value}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // Custom painter for the knob indicator (the line/grip that shows the current position)
// class KnobIndicatorPainter extends CustomPainter {
//   final bool isDragging;

//   KnobIndicatorPainter({this.isDragging = false});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;

//     // Draw the indicator line/grip pointing outward from the knob
//     // The line starts from near the center and extends outward
//     final lineStart = Offset(center.dx, center.dy - radius * 0.45);
//     final lineEnd = Offset(center.dx, center.dy - radius * 0.82);

//     // Create glow effect when dragging
//     if (isDragging) {
//       final glowPaint = Paint()
//         ..color = Colors.white.withOpacity(0.5)
//         ..strokeWidth = 8.0
//         ..strokeCap = StrokeCap.round
//         ..style = PaintingStyle.stroke;
//       canvas.drawLine(lineStart, lineEnd, glowPaint);
//     }

//     // Main indicator line
//     final linePaint = Paint()
//       ..color = Colors.white.withOpacity(0.95)
//       ..strokeWidth = isDragging ? 4.5 : 3.5
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..shader = const LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [Colors.white, Colors.grey],
//       ).createShader(Rect.fromPoints(lineStart, lineEnd));

//     canvas.drawLine(lineStart, lineEnd, linePaint);

//     // Add a small dot at the tip for better visibility
//     final tipPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     canvas.drawCircle(lineEnd, isDragging ? 3.5 : 2.5, tipPaint);
//   }

//   @override
//   bool shouldRepaint(KnobIndicatorPainter oldDelegate) {
//     return oldDelegate.isDragging != isDragging;
//   }
// }

// class ScalePainter extends CustomPainter {
//   final int value;
//   final double startAngleDeg;
//   final double sweepDegrees;

//   ScalePainter({
//     required this.value,
//     required this.startAngleDeg,
//     required this.sweepDegrees,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2 - 20;

//     // Total number of smallest increments
//     const int totalTicks = 80;

//     for (int i = 0; i <= totalTicks; i++) {
//       final double calculatedValue = (i / totalTicks) * 200;
//       final bool isActive = calculatedValue <= value;

//       final double currentDeg = startAngleDeg + (i / totalTicks * sweepDegrees);
//       final double rad = currentDeg * pi / 180;

//       final bool isMajor = i % 10 == 0;
//       final bool isMid = i % 5 == 0 && !isMajor;

//       double tickLength = isMajor ? 16.0 : (isMid ? 11.0 : 7.0);
//       double strokeWidth = isMajor ? 3.0 : (isMid ? 2.0 : 1.2);

//       Color tickColor;
//       if (calculatedValue <= 100) {
//         tickColor = isActive
//             ? const Color(0xFF39FF14)
//             : Colors.green.withOpacity(0.25);
//       } else if (calculatedValue <= 150) {
//         tickColor = isActive
//             ? const Color(0xFFFF9F00)
//             : Colors.orange.withOpacity(0.25);
//       } else {
//         tickColor = isActive
//             ? const Color(0xFFFF3B30)
//             : Colors.red.withOpacity(0.25);
//       }

//       final tickPaint = Paint()
//         ..color = tickColor
//         ..strokeWidth = strokeWidth
//         ..style = PaintingStyle.stroke;

//       final startPoint = Offset(
//         center.dx + (radius - tickLength) * cos(rad),
//         center.dy + (radius - tickLength) * sin(rad),
//       );
//       final endPoint = Offset(
//         center.dx + radius * cos(rad),
//         center.dy + radius * sin(rad),
//       );

//       canvas.drawLine(startPoint, endPoint, tickPaint);

//       if (isMajor) {
//         final int displayValue = calculatedValue.round();

//         Color textColor = Colors.grey.shade400;
//         if (displayValue == value) {
//           textColor = Colors.white;
//         } else if (displayValue == 200) {
//           textColor = Colors.white;
//         }

//         final textStyle = TextStyle(
//           color: textColor,
//           fontSize: displayValue == 200 ? 15 : 13,
//           fontWeight: displayValue == 200 ? FontWeight.w900 : FontWeight.w500,
//           fontFamily: 'SF Pro Display',
//           shadows: [
//             Shadow(
//               color: Colors.black.withOpacity(0.5),
//               blurRadius: 2,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         );

//         final textSpan = TextSpan(text: '$displayValue', style: textStyle);
//         final textPainter = TextPainter(
//           text: textSpan,
//           textDirection: TextDirection.ltr,
//         );
//         textPainter.layout();

//         final double labelRadius = radius + 20;
//         final labelPosition = Offset(
//           center.dx + labelRadius * cos(rad) - (textPainter.width / 2),
//           center.dy + labelRadius * sin(rad) - (textPainter.height / 2),
//         );

//         textPainter.paint(canvas, labelPosition);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(ScalePainter oldDelegate) {
//     return oldDelegate.value != value;
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volume Booster Fresh',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const VolumeBoosterScreen(),
    );
  }
}

class VolumeBoosterScreen extends StatefulWidget {
  const VolumeBoosterScreen({super.key});

  @override
  State<VolumeBoosterScreen> createState() => _VolumeBoosterScreenState();
}

class _VolumeBoosterScreenState extends State<VolumeBoosterScreen> {
  int _currentValue = 100; // Start at 100% (normal volume)
  bool _isBoosting = false;
  bool _isDragging = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isTestingAudio = false;

  @override
  void initState() {
    super.initState();
    _initVolumeControl();
  }

  Future<void> _initVolumeControl() async {
    try {
      await FlutterVolumeController.setVolume(_currentValue / 100);
      await FlutterVolumeController.showSystemUI;
    } catch (e) {
      debugPrint('Error initializing volume control: $e');
    }
  }

  void _handleValueChanged(int value) async {
    setState(() {
      _currentValue = value;
      _isBoosting = value > 100;
    });

    // Update system volume (0-200% maps to 0-100% system volume)
    final systemVolume = (value / 200).clamp(0.0, 1.0);
    try {
      await FlutterVolumeController.setVolume(systemVolume);
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }

    // Play test sound if testing is enabled
    if (_isTestingAudio) {
      await _playTestSound();
    }
  }

  Future<void> _playTestSound() async {
    try {
      await _audioPlayer.setVolume(_currentValue / 200);
      // Play a test tone or use existing asset
      // For demonstration, we'll just adjust volume without playing
    } catch (e) {
      debugPrint('Error playing test sound: $e');
    }
  }

  void _toggleTestSound() async {
    if (_isTestingAudio) {
      await _audioPlayer.stop();
      setState(() => _isTestingAudio = false);
    } else {
      setState(() => _isTestingAudio = true);
      // Try to play a test sound - you can add an asset or use a URL
      try {
        await _audioPlayer.play(AssetSource('audio/subwoofer_test.mp3'));
        _audioPlayer.onPlayerComplete.listen((event) {
          if (_isTestingAudio) {
            _audioPlayer.play(AssetSource('audio/subwoofer_test.mp3'));
          }
        });
      } catch (e) {
        debugPrint('Error playing test audio: $e');
        // Fallback: just vibrate to indicate test mode
        await Vibration.vibrate(duration: 100);
      }
    }
  }

  void _resetToNormal() {
    _handleValueChanged(100);
    HapticFeedback.mediumImpact();
  }

  void _boostMax() {
    _handleValueChanged(200);
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Text(
                'VOLUME BOOSTER',
                style: GoogleFonts.orbitron(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: _isBoosting ? Colors.green : Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isBoosting ? 'BOOST MODE ACTIVE' : 'NORMAL MODE',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  letterSpacing: 2,
                  color: _isBoosting ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              // Knob
              Center(
                child: MetallicKnob(
                  value: _currentValue,
                  onChanged: _handleValueChanged,
                  onDragStart: () {
                    setState(() => _isDragging = true);
                    HapticFeedback.lightImpact();
                  },
                  onDragEnd: () {
                    setState(() => _isDragging = false);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Value display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: _isBoosting
                        ? Colors.green.withOpacity(0.5)
                        : Colors.white24,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'VOLUME',
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        letterSpacing: 2,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${_currentValue}%',
                      style: GoogleFonts.orbitron(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _currentValue > 100
                            ? Colors.green
                            : _currentValue < 100
                            ? Colors.orange
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_isBoosting)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.flash_on, size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              '+${_currentValue - 100}%',
                              style: GoogleFonts.orbitron(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                        icon: Icons.replay,
                        label: 'NORMAL',
                        onPressed: _resetToNormal,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildButton(
                        icon: Icons.flash_on,
                        label: 'MAX BOOST',
                        onPressed: _boostMax,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Test sound toggle
              GestureDetector(
                onTap: _toggleTestSound,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _isTestingAudio
                        ? Colors.green.withOpacity(0.2)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isTestingAudio ? Colors.green : Colors.white24,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isTestingAudio ? Icons.volume_up : Icons.volume_off,
                        size: 16,
                        color: _isTestingAudio ? Colors.green : Colors.white54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isTestingAudio ? 'TEST SOUND ON' : 'TEST SOUND OFF',
                        style: GoogleFonts.orbitron(
                          fontSize: 11,
                          letterSpacing: 1,
                          color: _isTestingAudio
                              ? Colors.green
                              : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Warning for high volume
              if (_currentValue > 150)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'HIGH VOLUME MAY DAMAGE HEARING',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          letterSpacing: 1,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// Metallic Knob Widget with 0-200 scale
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
  bool _isDragging = false;

  static const double _minAngle = -pi * 0.75; // -135 degrees
  static const double _maxAngle = pi * 0.75; // 135 degrees

  @override
  void initState() {
    super.initState();
    _updateAngleFromValue(widget.value);
  }

  @override
  void didUpdateWidget(MetallicKnob oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isDragging) {
      _updateAngleFromValue(widget.value);
    }
  }

  void _updateAngleFromValue(int value) {
    setState(() {
      _currentAngle = _minAngle + (value / 200) * (_maxAngle - _minAngle);
    });
  }

  void _handlePanUpdate(DragUpdateDetails details, RenderBox box) {
    final center = box.size.center(Offset.zero);
    final position = details.localPosition;
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;

    double angle = atan2(dy, dx);

    // Clamp angle to range
    if (angle < _minAngle) angle = _minAngle;
    if (angle > _maxAngle) angle = _maxAngle;

    final value = ((angle - _minAngle) / (_maxAngle - _minAngle) * 200).round();
    final clampedValue = value.clamp(0, 200);

    if (clampedValue != widget.value) {
      widget.onChanged(clampedValue);
      setState(() {
        _currentAngle = angle;
      });
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: SizedBox(
          width: 280,
          height: 280,
          child: CustomPaint(
            painter: MetallicKnobPainter(
              angle: _currentAngle,
              value: widget.value,
            ),
          ),
        ),
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

    // Outer metallic ring - dark grey with metallic shine
    final outerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          const Color(0xFF666666),
          const Color(0xFF333333),
          const Color(0xFF1A1A1A),
          const Color(0xFF444444),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outerPaint);

    // Outer bezel
    final bezelPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 2, bezelPaint);

    // Inner metallic face
    final innerRadius = radius - 18;
    final innerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.2, 0.2),
        colors: [
          const Color(0xFF999999),
          const Color(0xFF555555),
          const Color(0xFF333333),
          const Color(0xFF222222),
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, innerPaint);

    // Inner ring border
    final innerBorderPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, innerRadius - 2, innerBorderPaint);

    // Draw 0-200 scale markers and labels
    const double startAngle = -pi * 0.75;
    const double endAngle = pi * 0.75;
    const double range = endAngle - startAngle;

    final markerPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2;
    final smallMarkerPaint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 1;

    final textStyle = TextStyle(
      color: Colors.white70,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      fontFamily: 'monospace',
    );

    // Draw tick marks - every 10 units from 0 to 200
    for (int i = 0; i <= 20; i++) {
      final percentage = i * 10; // 0, 10, 20... 200
      final markerAngle = startAngle + (percentage / 200) * range;

      final bool isMajor = percentage % 20 == 0;
      final bool isHalf = percentage % 10 == 0 && !isMajor;

      final paint = isMajor ? markerPaint : smallMarkerPaint;
      final length = isMajor ? 16.0 : 10.0;

      final startPoint = Offset(
        center.dx + (innerRadius - 12) * cos(markerAngle),
        center.dy + (innerRadius - 12) * sin(markerAngle),
      );
      final endPoint = Offset(
        center.dx + (innerRadius - 12 - length) * cos(markerAngle),
        center.dy + (innerRadius - 12 - length) * sin(markerAngle),
      );

      canvas.drawLine(startPoint, endPoint, paint);

      // Draw label for major ticks
      if (isMajor) {
        final labelRadius = innerRadius - 32;
        final labelPoint = Offset(
          center.dx + labelRadius * cos(markerAngle),
          center.dy + labelRadius * sin(markerAngle),
        );

        final label = percentage.toString();
        final textSpan = TextSpan(text: label, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          labelPoint - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }

    // Draw 0 and 200 labels at ends
    const double zeroAngle = -pi * 0.75;
    const double twoHundredAngle = pi * 0.75;
    final double labelRadius = innerRadius - 32;

    final endTextStyle = TextStyle(
      color: value == 0 ? Colors.red : Colors.white54,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );

    // "0" label
    final zeroPoint = Offset(
      center.dx + labelRadius * cos(zeroAngle),
      center.dy + labelRadius * sin(zeroAngle),
    );
    final zeroSpan = TextSpan(text: '0', style: endTextStyle);
    final zeroPainter = TextPainter(
      text: zeroSpan,
      textDirection: TextDirection.ltr,
    );
    zeroPainter.layout();
    zeroPainter.paint(
      canvas,
      zeroPoint - Offset(zeroPainter.width / 2, zeroPainter.height / 2),
    );

    // "200" label
    final twoHundredPoint = Offset(
      center.dx + labelRadius * cos(twoHundredAngle),
      center.dy + labelRadius * sin(twoHundredAngle),
    );
    final twoHundredSpan = TextSpan(text: '200', style: endTextStyle);
    final twoHundredPainter = TextPainter(
      text: twoHundredSpan,
      textDirection: TextDirection.ltr,
    );
    twoHundredPainter.layout();
    twoHundredPainter.paint(
      canvas,
      twoHundredPoint -
          Offset(twoHundredPainter.width / 2, twoHundredPainter.height / 2),
    );

    // Knob indicator line (the moving part)
    final indicatorLength = innerRadius - 20;
    final indicatorPoint = Offset(
      center.dx + indicatorLength * cos(angle),
      center.dy + indicatorLength * sin(angle),
    );

    // Draw indicator line from center to edge
    final linePaint = Paint()
      ..color = value > 100 ? Colors.green : Colors.orange
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, indicatorPoint, linePaint);

    // Draw glow effect when boosted
    if (value > 100) {
      final glowPaint = Paint()
        ..color = Colors.green.withOpacity(0.3 + (value - 100) / 100 * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(indicatorPoint, 16, glowPaint);
    }

    // Indicator circle at the end of line
    final indicatorPaint = Paint()
      ..color = value > 100 ? Colors.green : Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(indicatorPoint, 10, indicatorPaint);

    final innerIndicatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(indicatorPoint, 5, innerIndicatorPaint);

    // Center cap (screw/logo look)
    final capPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [Colors.grey[350]!, Colors.grey[600]!, Colors.grey[800]!],
      ).createShader(Rect.fromCircle(center: center, radius: 24))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 24, capPaint);

    final capRingPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 24, capRingPaint);

    final capInnerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.3, 0.3),
        colors: [Colors.grey[500]!, Colors.grey[700]!, Colors.grey[900]!],
      ).createShader(Rect.fromCircle(center: center, radius: 16))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 16, capInnerPaint);

    // Draw value indicator in center cap for boost mode
    if (value > 100) {
      final boostTextStyle = TextStyle(
        color: Colors.green,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      );
      final boostSpan = TextSpan(
        text: '+${value - 100}',
        style: boostTextStyle,
      );
      final boostPainter = TextPainter(
        text: boostSpan,
        textDirection: TextDirection.ltr,
      );
      boostPainter.layout();
      boostPainter.paint(
        canvas,
        center - Offset(boostPainter.width / 2, boostPainter.height / 2),
      );
    } else {
      final valueTextStyle = TextStyle(
        color: Colors.white70,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      );
      final valueSpan = TextSpan(text: '$value', style: valueTextStyle);
      final valuePainter = TextPainter(
        text: valueSpan,
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();
      valuePainter.paint(
        canvas,
        center - Offset(valuePainter.width / 2, valuePainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(MetallicKnobPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.value != value;
  }
}
