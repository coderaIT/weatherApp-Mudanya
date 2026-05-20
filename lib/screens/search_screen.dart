import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/error_widget.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_widget.dart';
import '../widgets/weather_card.dart';

/// Şehir Ara — şehir adı ile hava durumu sorgulama.
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
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _cityController,
                      style: const TextStyle(color: Color(0xFF1A237E)),
                      decoration: InputDecoration(
                        hintText: 'Şehir adı giriniz',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.95),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF5C6BC0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _searchWeather(),
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
