import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/weather_condition.dart';

/// Tüm hava durumları için yerleşik animasyon (Lottie / harici dosya yok).
class BuiltinWeatherAnimation extends StatefulWidget {
  final WeatherCondition condition;
  final double size;

  const BuiltinWeatherAnimation({
    super.key,
    required this.condition,
    this.size = 150,
  });

  @override
  State<BuiltinWeatherAnimation> createState() => _BuiltinWeatherAnimationState();
}

class _BuiltinWeatherAnimationState extends State<BuiltinWeatherAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _WeatherScenePainter(
              condition: widget.condition,
              progress: _controller.value,
            ),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}

class _WeatherScenePainter extends CustomPainter {
  final WeatherCondition condition;
  final double progress;

  _WeatherScenePainter({required this.condition, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    switch (condition) {
      case WeatherCondition.clearDay:
        _paintSun(canvas, size, night: false);
      case WeatherCondition.clearNight:
        _paintMoon(canvas, size);
      case WeatherCondition.partlyCloudyDay:
        _paintSun(canvas, size, night: false, dimmed: true);
        _paintClouds(canvas, size, drift: progress, opacity: 0.85);
      case WeatherCondition.partlyCloudyNight:
        _paintMoon(canvas, size, dimmed: true);
        _paintClouds(canvas, size, drift: progress, opacity: 0.7, dark: true);
      case WeatherCondition.cloudy:
        _paintClouds(canvas, size, drift: progress);
      case WeatherCondition.overcast:
        _paintClouds(canvas, size, drift: progress, dense: true);
      case WeatherCondition.drizzle:
        _paintClouds(canvas, size, drift: progress * 0.5, dense: true);
        _paintRain(canvas, size, light: true);
      case WeatherCondition.rain:
        _paintClouds(canvas, size, drift: progress * 0.5, dense: true);
        _paintRain(canvas, size);
      case WeatherCondition.thunderstorm:
        _paintClouds(canvas, size, drift: progress * 0.3, dense: true, dark: true);
        _paintRain(canvas, size, heavy: true);
        _paintLightning(canvas, size);
      case WeatherCondition.snow:
        _paintClouds(canvas, size, drift: progress * 0.4, light: true);
        _paintSnow(canvas, size);
      case WeatherCondition.mist:
        _paintFog(canvas, size);
    }
  }

  void _paintSun(Canvas canvas, Size size,
      {required bool night, bool dimmed = false}) {
    if (night) return;
    final center = Offset(size.width * 0.5, size.height * 0.42);
    final sunPaint = Paint()
      ..color = dimmed ? const Color(0xFFFFB74D) : const Color(0xFFFFCA28);
    canvas.drawCircle(center, size.width * 0.18, sunPaint);

    final rayPaint = Paint()
      ..color = dimmed ? const Color(0xFFFFB74D) : const Color(0xFFFFD54F)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final angle = (i / 8) * math.pi * 2 + progress * math.pi * 2;
      final inner = size.width * 0.22;
      final outer = size.width * 0.32;
      canvas.drawLine(
        center + Offset(math.cos(angle) * inner, math.sin(angle) * inner),
        center + Offset(math.cos(angle) * outer, math.sin(angle) * outer),
        rayPaint,
      );
    }
  }

  void _paintMoon(Canvas canvas, Size size, {bool dimmed = false}) {
    final center = Offset(size.width * 0.48, size.height * 0.38);
    final moon = Paint()
      ..color = dimmed ? const Color(0xFFB0BEC5) : const Color(0xFFECEFF1);
    canvas.drawCircle(center, size.width * 0.14, moon);

    final shadow = Paint()..color = const Color(0xFF37474F);
    canvas.drawCircle(
      center + Offset(size.width * 0.05, 0),
      size.width * 0.12,
      shadow,
    );

    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7 + 0.3 * math.sin(progress * math.pi * 4));
    for (var i = 0; i < 6; i++) {
      final seed = i * 17.0;
      final x = (seed % 70 + 15) / 100 * size.width;
      final y = (seed % 50 + 10) / 100 * size.height;
      canvas.drawCircle(Offset(x, y), 1.5 + (i % 2), starPaint);
    }
  }

  void _paintClouds(
    Canvas canvas,
    Size size, {
    required double drift,
    double opacity = 1,
    bool dense = false,
    bool dark = false,
    bool light = false,
  }) {
    final base = dark
        ? const Color(0xFF455A64)
        : light
            ? const Color(0xFFECEFF1)
            : const Color(0xFF90A4AE);
    final paint = Paint()
      ..color = base.withValues(alpha: (dense ? 0.95 : 0.75) * opacity);

    void cloud(Offset c, double scale) {
      canvas.drawCircle(c, 18 * scale, paint);
      canvas.drawCircle(c + Offset(22 * scale, 4), 14 * scale, paint);
      canvas.drawCircle(c + Offset(-18 * scale, 6), 12 * scale, paint);
    }

    final offset = drift * size.width * 0.08;
    cloud(Offset(size.width * 0.35 + offset, size.height * 0.38), dense ? 1.3 : 1.0);
    cloud(Offset(size.width * 0.62 - offset, size.height * 0.48), dense ? 1.1 : 0.85);
    if (dense) {
      cloud(Offset(size.width * 0.5, size.height * 0.32), 1.0);
    }
  }

  void _paintRain(Canvas canvas, Size size,
      {bool light = false, bool heavy = false}) {
    final count = heavy ? 28 : light ? 12 : 20;
    final paint = Paint()
      ..color = heavy ? const Color(0xFF1565C0) : const Color(0xFF42A5F5)
      ..strokeWidth = heavy ? 2.5 : 2
      ..strokeCap = StrokeCap.round;
    final random = math.Random(11);
    for (var i = 0; i < count; i++) {
      final seed = random.nextDouble();
      final x = (seed * 0.85 + 0.08) * size.width;
      final phase = (progress * (0.8 + seed) + seed) % 1.0;
      final y = size.height * 0.42 + phase * size.height * 0.5;
      final len = heavy ? 14.0 : light ? 8.0 : 11.0;
      canvas.drawLine(Offset(x, y), Offset(x - 4, y + len), paint);
    }
  }

  void _paintLightning(Canvas canvas, Size size) {
    if ((progress * 3).floor() % 2 != 0) return;
    final path = Path()
      ..moveTo(size.width * 0.55, size.height * 0.35)
      ..lineTo(size.width * 0.48, size.height * 0.5)
      ..lineTo(size.width * 0.58, size.height * 0.48)
      ..lineTo(size.width * 0.5, size.height * 0.68);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFFEE58)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _paintSnow(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    final random = math.Random(13);
    for (var i = 0; i < 24; i++) {
      final seed = random.nextDouble();
      final x = (seed * 0.9 + 0.05) * size.width;
      final phase = (progress * (0.4 + seed * 0.3) + seed) % 1.0;
      final y = size.height * 0.35 + phase * size.height * 0.55;
      final wobble = math.sin((progress + seed) * math.pi * 2) * 6;
      canvas.drawCircle(Offset(x + wobble, y), 2 + seed, paint);
    }
  }

  void _paintFog(Canvas canvas, Size size) {
    for (var band = 0; band < 4; band++) {
      final y = size.height * (0.35 + band * 0.12);
      final alpha = 0.25 + 0.15 * math.sin(progress * math.pi * 2 + band);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(-10, y, size.width + 20, 28),
        const Radius.circular(14),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherScenePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.condition != condition;
}
