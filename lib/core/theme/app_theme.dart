import 'package:flutter/material.dart';

/// দুটো theme (dark/light) এখানে সংজ্ঞায়িত — নতুন স্ক্রিন লেখার সময়
/// hardcoded hex এর বদলে সবসময় Theme.of(context).colorScheme ব্যবহার করবেন,
/// তাহলে ভবিষ্যতে light/dark দুটোতেই ঠিকভাবে কাজ করবে।
class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF56CCF2);
  static const Color secondary = Color(0xFF6FCF97);
  static const Color error = Color(0xFFEB5757);

  static const Color darkBackground = Color(0xFF0E0E11);
  static const Color darkSurface = Color(0xFF1B1B1F);

  static const Color lightBackground = Color(0xFFF5F6F8);
  static const Color lightSurface = Color(0xFFFFFFFF);

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: darkBackground,
        surface: darkSurface,
        onSurface: Colors.white,
        onSurfaceMuted: Colors.grey.shade400,
      );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: lightBackground,
        surface: lightSurface,
        onSurface: const Color(0xFF1B1B1F),
        onSurfaceMuted: Colors.grey.shade600,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceMuted,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.black,
        secondary: secondary,
        onSecondary: Colors.black,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: onSurface, fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: onSurface),
      ),
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme.apply(
            bodyColor: onSurface,
            displayColor: onSurface,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: onSurfaceMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      dividerColor: onSurfaceMuted.withOpacity(0.2),
    );
  }
}
