import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city_suggestion.dart';
import '../providers/weather_provider.dart';
import '../utils/constants.dart';
import '../widgets/city_autocomplete_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/error_widget.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_widget.dart';
import '../widgets/weather_card.dart';

/// Şehir Ara — otomatik tamamlama ile hava durumu sorgulama.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _cityController = TextEditingController();
  String? _validationError;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _searchWeather() async {
    final city = _cityController.text.trim();

    if (city.isEmpty) {
      setState(() {
        _validationError = AppConstants.errorEmptyCity;
      });
      return;
    }

    setState(() => _validationError = null);
    await context.read<WeatherProvider>().fetchWeatherByCity(city);
  }

  Future<void> _onSuggestionSelected(CitySuggestion city) async {
    setState(() => _validationError = null);
    await context.read<WeatherProvider>().fetchWeatherBySuggestion(city);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Şehir Ara',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Şehir yazın veya listeden seçin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CityAutocompleteField(
                      controller: _cityController,
                      onSearchSubmitted: _searchWeather,
                      onSuggestionSelected: _onSuggestionSelected,
                    ),
                  ),
                  if (_validationError != null) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _validationError!,
                        style: TextStyle(
                          color: Colors.amber.shade100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: 'Hava Durumunu Getir',
                      icon: Icons.cloud,
                      isLoading: provider.searchIsLoading,
                      onPressed: _searchWeather,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (provider.searchIsLoading)
                    const Padding(
                      padding: EdgeInsets.all(48),
                      child: LoadingWidget(
                        message: 'Şehir aranıyor...',
                      ),
                    )
                  else if (provider.searchErrorMessage != null)
                    ErrorDisplayWidget(
                      message: provider.searchErrorMessage!,
                      onRetry: _searchWeather,
                    )
                  else if (provider.searchWeather != null)
                    WeatherCard(weather: provider.searchWeather!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
