/// Geocoding API veya öneri listesinden gelen şehir satırı.
class CitySuggestion {
  final String name;
  final String? state;
  final String country;
  final double lat;
  final double lon;

  const CitySuggestion({
    required this.name,
    this.state,
    required this.country,
    required this.lat,
    required this.lon,
  });

  String get displayLabel {
    final parts = <String>[name];
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (country.isNotEmpty) parts.add(country);
    return parts.join(', ');
  }

  factory CitySuggestion.fromJson(Map<String, dynamic> json) {
    return CitySuggestion(
      name: json['name'] as String? ?? '',
      state: json['state'] as String?,
      country: json['country'] as String? ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }
}
