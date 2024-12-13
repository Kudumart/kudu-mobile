import 'package:intl/intl.dart';

class PriceFormatter {
  static String formatPrice({required double price, required String currency}) {
    final format = NumberFormat.currency(
        locale: "en-US", symbol: currency, decimalDigits: 0);
    return format.format(price);
  }
}
