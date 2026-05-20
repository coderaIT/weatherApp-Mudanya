import 'package:flutter/material.dart';

import '../utils/weather_condition.dart';
import 'builtin_weather_animations.dart';

/// Hava durumuna göre animasyon — tüm OpenWeather ikon kodları desteklenir.
class WeatherAnimation extends StatelessWidget {
  final String iconCode;
  final String description;
  final double size;

  const WeatherAnimation({
    super.key,
    required this.iconCode,
    this.description = '',
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    final condition = WeatherConditionParser.fromIconCode(
      iconCode,
      description: description,
    );

    return BuiltinWeatherAnimation(
      condition: condition,
      size: size,
    );
  }
}
