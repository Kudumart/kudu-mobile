import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static late final SharedPreferencesWithCache _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions());
  }

  static Future<void> clear() async => await _prefs.clear();

  static Future<void> saveAuthenticationToken(String token) {
    return _prefs.setString("auth-token", token);
  }

  static String? get authenticationToken => _prefs.getString("auth-token");

  static Future<void> saveUserEmail(String email) {
    return _prefs.setString("email", email);
  }

  static String? get userEmail => _prefs.getString("email");

  static Future<void> saveUserFirstname(String firstname) {
    return _prefs.setString("first-name", firstname);
  }

  static String? get firstName => _prefs.getString("first-name");

  static Future logout() async {
    await clear();
  }
}
