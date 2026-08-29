import 'package:flutter/foundation.dart';
import 'package:kudu/core/services/utility_storage_service.dart';

class AppCountry {
  final String value; // "Nigeria", "United States", "United Kingdom"
  final String label; // "NGA", "USA", "UK"
  final String flag;  // "🇳🇬", "🇺🇸", "🇬🇧"
  final String currencySymbol; // "₦", "$", "£"
  final String currencyCode;   // "NGN", "USD", "GBP"

  const AppCountry({
    required this.value,
    required this.label,
    required this.flag,
    required this.currencySymbol,
    required this.currencyCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCountry &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class CountryService extends ChangeNotifier {
  static const String storageKey = 'selected_country_value';

  static const List<AppCountry> supportedCountries = [
    AppCountry(
      value: "Nigeria",
      label: "NGA",
      flag: "🇳🇬",
      currencySymbol: "₦",
      currencyCode: "NGN",
    ),
    AppCountry(
      value: "United States",
      label: "USA",
      flag: "🇺🇸",
      currencySymbol: "\$",
      currencyCode: "USD",
    ),
    AppCountry(
      value: "United Kingdom",
      label: "UK",
      flag: "🇬🇧",
      currencySymbol: "£",
      currencyCode: "GBP",
    ),
  ];

  static AppCountry get defaultCountry => supportedCountries[0]; // Nigeria

  AppCountry _selectedCountry = defaultCountry;

  AppCountry get selectedCountry => _selectedCountry;
  String get selectedCountryValue => _selectedCountry.value;
  String get selectedCountryLabel => _selectedCountry.label;
  String get selectedCountryFlag => _selectedCountry.flag;
  String get currencySymbol => _selectedCountry.currencySymbol;
  String get currencyCode => _selectedCountry.currencyCode;

  CountryService() {
    _loadSelectedCountry();
  }

  void _loadSelectedCountry() {
    try {
      final savedValue = StorageService().getString(storageKey);
      if (savedValue != null && savedValue.isNotEmpty) {
        final match = supportedCountries.firstWhere(
          (c) => c.value.toLowerCase() == savedValue.toLowerCase(),
          orElse: () => defaultCountry,
        );
        _selectedCountry = match;
      } else {
        _selectedCountry = defaultCountry;
      }
    } catch (_) {
      _selectedCountry = defaultCountry;
    }
  }

  Future<void> setCountry(AppCountry country) async {
    if (_selectedCountry.value == country.value) return;
    _selectedCountry = country;
    try {
      StorageService().addString(storageKey, country.value);
    } catch (_) {}
    notifyListeners();
  }
}