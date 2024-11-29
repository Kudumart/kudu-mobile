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
}