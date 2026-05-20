import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'weather_animation.dart';

/// Hava durumu bilgilerini modern bir kartta gösterir.
class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Şehir adı
          Text(
            weather.cityName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 12),
          WeatherAnimation(
            iconCode: weather.iconCode,
            description: weather.description,
            size: 150,
          ),
          const SizedBox(height: 8),
          Text(
            _capitalize(weather.description),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Ana sıcaklık
          Text(
            '${weather.temperature.round()}°C',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w300,
              color: Color(0xFF283593),
            ),
          ),
          const SizedBox(height: 20),
          // Detay satırları
          _buildDetailRow(
            Icons.thermostat_outlined,
            'Hissedilen',
            '${weather.feelsLike.round()}°C',
          ),
          const Divider(height: 24),
          _buildDetailRow(
            Icons.water_drop_outlined,
            'Nem',
            '%${weather.humidity}',
          ),
          const Divider(height: 24),
          _buildDetailRow(
            Icons.air,
            'Rüzgar',
            '${weather.windSpeed.toStringAsFixed(1)} m/s',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5C6BC0), size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
