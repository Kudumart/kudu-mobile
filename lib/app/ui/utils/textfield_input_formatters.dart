import 'package:flutter/services.dart';
import 'package:kudu/app/ui/utils/price_formatter.dart';

class MoneyInputFormatter extends TextInputFormatter {
  final String currencySymbol;

  /// [MoneyInputFormatter] format the amount entered to a more readable format and adds [currencySymbol] as a prefix.
  /// For example, if user enters 300000 and [currencySymbol] is $, the input is formatted to $300,000 
  MoneyInputFormatter({required this.currencySymbol});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove the currency symbol if it already exists
    String newText = newValue.text.replaceAll(currencySymbol, '');

    if (double.tryParse(newText) != null) {
      newText = PriceFormatter.formatPrice(
          price: double.parse(newText), currency: "");
    }

    // Re-add the currency symbol
    final formattedText = '$currencySymbol$newText';

    // Maintain the cursor position after the prefix
    final cursorPosition = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class MoneyFormatter extends TextInputFormatter {
  final String currencySymbol;

  /// [MoneyFormatter] format the amount entered to a more readable format and adds [currencySymbol] as a prefix.
  /// For example, if user enters 300000 and [currencySymbol] is $, the input is formatted to $300,000 
  MoneyFormatter({required this.currencySymbol});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove the currency symbol if it already exists
    String newText = newValue.text.replaceAll(currencySymbol, '');

    if (double.tryParse(newText) != null) {
      newText = PriceFormatter.formatPrice(
          price: double.parse(newText), currency: "");
    }

    // Re-add the currency symbol
    final formattedText = '$currencySymbol$newText';

    // Maintain the cursor position after the prefix
    final cursorPosition = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
