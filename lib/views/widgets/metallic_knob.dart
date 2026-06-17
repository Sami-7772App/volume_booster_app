
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

class _VolumeBoosterScreenState extends State<VolumeBoosterScreen> with SingleTickerProviderStateMixin {
  int _currentValue = 100; // Start at 100% (normal volume)
  bool _isBoosting = false;
  bool _isDragging = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isTestingAudio = false;

  // Animation for smooth transitions
  late AnimationController _animationController;
  int _targetValue = 100;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _initVolumeControl();

    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addListener(() {
          // Update value during animation
          final currentAnimValue = _animationController.value;
          final int animatedValue =
              ((_targetValue - _currentValue) * currentAnimValue +
                      _currentValue)
                  .round();
          if (animatedValue != _currentValue && !_isDragging) {
            _updateValue(animatedValue, fromAnimation: true);
          }
        });
  }

  Future<void> _initVolumeControl() async {
    try {
      await FlutterVolumeController.setVolume(_currentValue / 100);
      await FlutterVolumeController.showSystemUI;
    } catch (e) {
      debugPrint('Error initializing volume control: $e');
    }
  }

  void _updateValue(int value, {bool fromAnimation = false}) {
    if (_currentValue == value) return;

    setState(() {
      _currentValue = value;
      _isBoosting = value > 100;
    });

    // Update system volume
    final systemVolume = (value / 200).clamp(0.0, 1.0);
    try {
      FlutterVolumeController.setVolume(systemVolume);
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }

    // Play test sound if testing is enabled
    if (_isTestingAudio) {
      _playTestSound();
    }
  }

  void _handleValueChanged(int value) {
    if (_isAnimating) return;

    // Clamp value
    value = value.clamp(0, 200);

    // Check if jump is too large
    final int difference = (value - _currentValue).abs();
    const int maxJump = 10;

    if (difference > maxJump) {
      // Start smooth animation to target
      _targetValue = value;
      _isAnimating = true;

      // Reset animation controller
      _animationController.reset();
      _animationController.forward().then((_) {
        _isAnimating = false;
        // Ensure final value is set
        _updateValue(_targetValue);
      });
    } else {
      // Direct update for small changes
      _updateValue(value);
    }
  }

  Future<void> _playTestSound() async {
    try {
      await _audioPlayer.setVolume(_currentValue / 200);
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
      try {
        await _audioPlayer.play(AssetSource('audio/subwoofer_test.mp3'));
        _audioPlayer.onPlayerComplete.listen((event) {
          if (_isTestingAudio) {
            _audioPlayer.play(AssetSource('audio/subwoofer_test.mp3'));
          }
        });
      } catch (e) {
        debugPrint('Error playing test audio: $e');
        await Vibration.vibrate(duration: 100);
      }
    }
  }

  void _resetToNormal() {
    if (_isAnimating) return;
    _targetValue = 100;
    _isAnimating = true;
    _animationController.reset();
    _animationController.forward().then((_) {
      _isAnimating = false;
      _updateValue(100);
    });
    HapticFeedback.mediumImpact();
  }

  void _boostMax() {
    if (_isAnimating) return;
    _targetValue = 200;
    _isAnimating = true;
    _animationController.reset();
    _animationController.forward().then((_) {
      _isAnimating = false;
      _updateValue(200);
    });
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Function to get needle color based on value
  Color _getNeedleColor(int value) {
    if (value <= 100) {
      return Colors.green;
    } else if (value <= 150) {
      double progress = (value - 100) / 50;
      return Color.lerp(Colors.green, Colors.amber, progress)!;
    } else if (value <= 200) {
      double progress = (value - 150) / 50;
      return Color.lerp(Colors.amber, Colors.red, progress)!;
    }
    return Colors.red;
  }

  // Function to get glow color based on value
  Color _getGlowColor(int value) {
    if (value <= 100) {
      return Colors.green.withOpacity(0.1);
    } else if (value <= 150) {
      double progress = (value - 100) / 50;
      return Color.lerp(
        Colors.green.withOpacity(0.2),
        Colors.amber.withOpacity(0.4),
        progress,
      )!;
    } else if (value <= 200) {
      double progress = (value - 150) / 50;
      return Color.lerp(
        Colors.amber.withOpacity(0.4),
        Colors.red.withOpacity(0.6),
        progress,
      )!;
    }
    return Colors.red.withOpacity(0.6);
  }

  @override
  Widget build(BuildContext context) {
    final needleColor = _getNeedleColor(_currentValue);
    final glowColor = _getGlowColor(_currentValue);

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
                  color: _isBoosting ? needleColor : Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isBoosting ? 'BOOST MODE ACTIVE' : 'NORMAL MODE',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  letterSpacing: 2,
                  color: _isBoosting ? needleColor : Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              // Knob with animated background glow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor,
                      blurRadius: _isBoosting ? 60 : 20,
                      spreadRadius: _isBoosting ? 20 : 5,
                    ),
                  ],
                ),
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
                  needleColor: needleColor,
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
                        ? needleColor.withOpacity(0.5)
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
                            ? needleColor
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
                          color: needleColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.flash_on, size: 16, color: needleColor),
                            const SizedBox(width: 4),
                            Text(
                              '+${_currentValue - 100}%',
                              style: GoogleFonts.orbitron(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: needleColor,
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
                        color: needleColor,
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
                        ? needleColor.withOpacity(0.2)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isTestingAudio ? needleColor : Colors.white24,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isTestingAudio ? Icons.volume_up : Icons.volume_off,
                        size: 16,
                        color: _isTestingAudio ? needleColor : Colors.white54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isTestingAudio ? 'TEST SOUND ON' : 'TEST SOUND OFF',
                        style: GoogleFonts.orbitron(
                          fontSize: 11,
                          letterSpacing: 1,
                          color: _isTestingAudio ? needleColor : Colors.white54,
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
  final Color needleColor;

  const MetallicKnob({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onDragStart,
    required this.onDragEnd,
    required this.needleColor,
  });

  @override
  State<MetallicKnob> createState() => _MetallicKnobState();
}

class _MetallicKnobState extends State<MetallicKnob> {
  double _currentAngle = 0;
  bool _isDragging = false;

  static const double _minAngle = -pi * 0.75;
  static const double _maxAngle = pi * 0.75;

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
              needleColor: widget.needleColor,
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
  final Color needleColor;

  MetallicKnobPainter({
    required this.angle,
    required this.value,
    required this.needleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer metallic ring
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
      fontSize: 10,
      fontWeight: FontWeight.w600,
      fontFamily: 'monospace',
    );

    // Draw tick marks
    for (int i = 0; i <= 20; i++) {
      final percentage = i * 10;
      final markerAngle = startAngle + (percentage / 200) * range;

      final bool isMajor = percentage % 20 == 0;
      final paint = isMajor ? markerPaint : smallMarkerPaint;
      final length = isMajor ? 12.0 : 8.0;

      final startOffset = 18.0;
      final startPoint = Offset(
        center.dx + (innerRadius - startOffset) * cos(markerAngle),
        center.dy + (innerRadius - startOffset) * sin(markerAngle),
      );
      final endPoint = Offset(
        center.dx + (innerRadius - startOffset - length) * cos(markerAngle),
        center.dy + (innerRadius - startOffset - length) * sin(markerAngle),
      );

      canvas.drawLine(startPoint, endPoint, paint);

      if (isMajor) {
        final labelRadius = innerRadius - 42;
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

    // Draw 0 and 200 labels
    const double zeroAngle = -pi * 0.75;
    const double twoHundredAngle = pi * 0.75;
    final double labelRadius = innerRadius - 42;

    final endTextStyle = TextStyle(
      color: value == 0 ? Colors.red : Colors.white54,
      fontSize: 11,
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

    // Knob indicator line
    final indicatorLength = innerRadius - 30;
    final indicatorPoint = Offset(
      center.dx + indicatorLength * cos(angle),
      center.dy + indicatorLength * sin(angle),
    );

    // Draw indicator line
    final linePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, indicatorPoint, linePaint);

    // Draw glow effect
    if (value > 100) {
      final glowIntensity = (value - 100) / 100;
      final glowPaint = Paint()
        ..color = needleColor.withOpacity(0.3 + glowIntensity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(indicatorPoint, 14, glowPaint);
    }

    // Indicator circle
    final indicatorPaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(indicatorPoint, 8, indicatorPaint);

    final innerIndicatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(indicatorPoint, 4, innerIndicatorPaint);

    // Center cap
    final capPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [Colors.grey[350]!, Colors.grey[600]!, Colors.grey[800]!],
      ).createShader(Rect.fromCircle(center: center, radius: 20))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20, capPaint);

    final capRingPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 20, capRingPaint);

    final capInnerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.3, 0.3),
        colors: [Colors.grey[500]!, Colors.grey[700]!, Colors.grey[900]!],
      ).createShader(Rect.fromCircle(center: center, radius: 14))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 14, capInnerPaint);

    // Draw value indicator in center cap
    if (value > 100) {
      final boostTextStyle = TextStyle(
        color: needleColor,
        fontSize: 9,
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
        fontSize: 9,
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
    return oldDelegate.angle != angle ||
        oldDelegate.value != value ||
        oldDelegate.needleColor != needleColor;
  }
}
