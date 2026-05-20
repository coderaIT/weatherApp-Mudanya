import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city_suggestion.dart';
import '../providers/weather_provider.dart';

/// Şehir arama alanı — yazarken öneri listesi gösterir.
class CityAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearchSubmitted;
  final ValueChanged<CitySuggestion>? onSuggestionSelected;

  const CityAutocompleteField({
    super.key,
    required this.controller,
    required this.onSearchSubmitted,
    this.onSuggestionSelected,
  });

  @override
  State<CityAutocompleteField> createState() => _CityAutocompleteFieldState();
}

class _CityAutocompleteFieldState extends State<CityAutocompleteField> {
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<CitySuggestion> _suggestions = [];
  bool _loadingSuggestions = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
    _loadSuggestions('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() => _showSuggestions = true);
      _loadSuggestions(widget.controller.text);
    }
  }

  void _onTextChanged() {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _loadSuggestions(widget.controller.text);
    });
  }

  Future<void> _loadSuggestions(String query) async {
    setState(() => _loadingSuggestions = true);
    final results =
        await context.read<WeatherProvider>().searchCitySuggestions(query);
    if (!mounted) return;
    setState(() {
      _suggestions = results;
      _loadingSuggestions = false;
    });
  }

  Widget? _buildClearButton() {
    if (widget.controller.text.isEmpty) return null;
    return IconButton(
      icon: const Icon(Icons.clear, color: Color(0xFF5C6BC0)),
      onPressed: () {
        widget.controller.clear();
        setState(() {});
        _loadSuggestions('');
      },
    );
  }

  void _selectSuggestion(CitySuggestion city) {
    widget.controller.text = city.name;
    setState(() => _showSuggestions = false);
    _focusNode.unfocus();
    widget.onSuggestionSelected?.call(city);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: const TextStyle(color: Color(0xFF1A237E)),
          decoration: InputDecoration(
            hintText: 'Şehir adı yazın (ör. Bursa, İstanbul)',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.95),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF5C6BC0),
            ),
            suffixIcon: _buildClearButton(),
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
          onSubmitted: (_) => widget.onSearchSubmitted(),
          onTap: () {
            setState(() => _showSuggestions = true);
            _loadSuggestions(widget.controller.text);
          },
        ),
        if (_showSuggestions && (_suggestions.isNotEmpty || _loadingSuggestions))
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _loadingSuggestions && _suggestions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      final city = _suggestions[index];
                      return ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.location_city,
                          color: Color(0xFF5C6BC0),
                        ),
                        title: Text(
                          city.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        subtitle: Text(
                          city.displayLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        onTap: () => _selectSuggestion(city),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}
