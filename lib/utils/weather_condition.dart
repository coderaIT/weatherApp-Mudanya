/// OpenWeather ikon kodlarına göre animasyon türü (gündüz/gece dahil).
enum WeatherCondition {
  clearDay,
  clearNight,
  partlyCloudyDay,
  partlyCloudyNight,
  cloudy,
  overcast,
  drizzle,
  rain,
  thunderstorm,
  snow,
  mist,
}

class WeatherConditionParser {
  WeatherConditionParser._();

  static WeatherCondition fromIconCode(
    String iconCode, {
    String description = '',
  }) {
    final code = iconCode.trim();
    if (code.length >= 2) {
      final id = code.substring(0, 2);
      final isNight = code.endsWith('n');
      switch (id) {
        case '01':
          return isNight ? WeatherCondition.clearNight : WeatherCondition.clearDay;
        case '02':
          return isNight
              ? WeatherCondition.partlyCloudyNight
              : WeatherCondition.partlyCloudyDay;
        case '03':
          return WeatherCondition.cloudy;
        case '04':
          return WeatherCondition.overcast;
        case '09':
          return WeatherCondition.drizzle;
        case '10':
          return WeatherCondition.rain;
        case '11':
          return WeatherCondition.thunderstorm;
        case '13':
          return WeatherCondition.snow;
        case '50':
          return WeatherCondition.mist;
      }
    }

    return _fromDescription(description);
  }

  static WeatherCondition _fromDescription(String description) {
    final d = description.toLowerCase();
    if (d.contains('thunder') ||
        d.contains('fırtına') ||
        d.contains('yıldır') ||
        d.contains('gök gür')) {
      return WeatherCondition.thunderstorm;
    }
    if (d.contains('snow') || d.contains('kar')) {
      return WeatherCondition.snow;
    }
    if (d.contains('drizzle') || d.contains('çisenti')) {
      return WeatherCondition.drizzle;
    }
    if (d.contains('rain') || d.contains('yağmur') || d.contains('shower')) {
      return WeatherCondition.rain;
    }
    if (d.contains('mist') ||
        d.contains('fog') ||
        d.contains('sis') ||
        d.contains('pus') ||
        d.contains('haze') ||
        d.contains('smoke')) {
      return WeatherCondition.mist;
    }
    if (d.contains('overcast') || d.contains('kapalı')) {
      return WeatherCondition.overcast;
    }
    if (d.contains('cloud') ||
        d.contains('bulut') ||
        d.contains('parçalı')) {
      return WeatherCondition.cloudy;
    }
    if (d.contains('clear') || d.contains('açık') || d.contains('güneş')) {
      return WeatherCondition.clearDay;
    }
    return WeatherCondition.cloudy;
  }
}
