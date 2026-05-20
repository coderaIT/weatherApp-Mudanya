/// OpenWeather API yanıtından oluşturulan hava durumu modeli.
class WeatherModel {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;
  final String cityName;

  WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.cityName,
  });

  /// One Call API 3.0 — `current` alanından parse eder.
  /// Dokümantasyon: current.temp, current.feels_like, current.humidity,
  /// current.wind_speed, current.weather[].description, current.weather[].icon
  factory WeatherModel.fromOneCallJson(
    Map<String, dynamic> json,
    String cityName,
  ) {
    final current = json['current'] as Map<String, dynamic>;
    final weatherList = current['weather'] as List<dynamic>;
    final weather = weatherList.first as Map<String, dynamic>;

    return WeatherModel(
      temperature: (current['temp'] as num).toDouble(),
      feelsLike: (current['feels_like'] as num).toDouble(),
      humidity: current['humidity'] as int,
      windSpeed: (current['wind_speed'] as num).toDouble(),
      description: weather['description'] as String? ?? '',
      iconCode: weather['icon'] as String? ?? '01d',
      cityName: cityName,
    );
  }

  /// Current Weather API 2.5 — One Call aboneliği olmadığında yedek.
  factory WeatherModel.fromCurrentWeatherJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>;
    final weather = weatherList.first as Map<String, dynamic>;

    return WeatherModel(
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0,
      description: weather['description'] as String? ?? '',
      iconCode: weather['icon'] as String? ?? '01d',
      cityName: json['name'] as String? ?? '',
    );
  }

  /// OpenWeather ikon URL'si (ör. 01d, 02n)
  String get iconUrl =>
      'https://openweathermap.org/img/wn/$iconCode@4x.png';
}
