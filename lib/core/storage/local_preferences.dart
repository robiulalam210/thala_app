import 'package:shared_preferences/shared_preferences.dart';

/// App-wide non-sensitive local settings (language, theme, onboarding state).
/// Credential/token er moto sensitive data er jonno flutter_secure_storage byবহার করবেন — এটা শুধু preference-level data এর জন্য।
class LocalPreferences {
  LocalPreferences._();

  static const _keyLanguage = 'thala_language';
  static const _keyThemeMode = 'thala_theme_mode'; // 'light' | 'dark' | 'system'
  static const _keyOnboardingComplete = 'thala_onboarding_complete';
  static const _keyProfileJson = 'thala_user_profile';

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage);
  }

  static Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, code);
  }

  static Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode);
  }

  static Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  static Future<void> setOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingComplete, value);
  }

  static Future<String?> getProfileJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileJson);
  }

  static Future<void> setProfileJson(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileJson, json);
  }
}
