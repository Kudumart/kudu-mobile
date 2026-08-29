import 'package:flutter/material.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/providers/home_provider.dart';
import 'package:kudu/services/country_service.dart';
import 'package:provider/provider.dart';

class CountrySelectDropdown extends StatelessWidget {
  final bool isDark;
  const CountrySelectDropdown({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryService>(
      builder: (context, countryService, child) {
        final currentCountry = countryService.selectedCountry;

        return PopupMenuButton<AppCountry>(
          initialValue: currentCountry,
          offset: const Offset(0, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          color: Colors.white,
          elevation: 4,
          onSelected: (AppCountry country) async {
            if (country.value != currentCountry.value) {
              await countryService.setCountry(country);
              if (context.mounted) {
                final homeProvider = Provider.of<HomeViewModel>(context, listen: false);
                homeProvider.clearProductCache();
                homeProvider.fetchAllProducts(context: context, force: true, showLoader: false);
              }
            }
          },
          itemBuilder: (BuildContext context) {
            return CountryService.supportedCountries.map((AppCountry country) {
              final isSelected = country.value == currentCountry.value;
              return PopupMenuItem<AppCountry>(
                value: country,
                height: 44,
                child: Row(
                  children: [
                    Text(
                      country.flag,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      country.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppUiColor.primary : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "(${country.value})",
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? AppUiColor.primary.withOpacity(0.8) : Colors.grey.shade600,
                      ),
                    ),
                    if (isSelected) ...[
                      const Spacer(),
                      const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: AppUiColor.primary,
                      ),
                    ],
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.12) : const Color(0xFFF4F4F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentCountry.flag,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(width: 4),
                Text(
                  currentCountry.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}