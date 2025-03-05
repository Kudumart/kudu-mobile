abstract class InputValidator {
  static String? validateEmail(String? input) {
    if (input == null || input.isEmpty) {
      return "Email is required";
    }
    if (!_isValidEmail(input)) {
      return "Invalid email address";
    }

    return null;
  }

   static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }
    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'Please enter a valid URL';
      }
      return null;
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }

  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  return emailRegex.hasMatch(email);
  }

  static String? validateEmailOrPhone(String? input) {
    if (input == null || input.isEmpty || input.length < 7) {
      return "Invalid input";
    }

    if (_isValidEmail(input) || input.length > 7) {
      return null;
    }

    return "Invalid input";
  }

  /// a generic validator to validate that [input] is at least two characters long
  static String? validateValidInput(String? input) {
    if (input == null || input.isEmpty || input.length < 2) {
      return "Invalid input";
    }
    return null;
  }

 

  static String? validatePrice(String? input) {
    final price = double.tryParse(input ?? "");
    if (price == null) {
      return "Invalid price";
    }
    return null;
  }
}