import 'package:flutter/material.dart';

/// 앱 테마 설정 (흙과 식물 느낌)
class AppTheme {
  static const _primary = Color(0xFF4CAF50); // 식물 그린
  static const _primaryContainer = Color(0xFF388E3C); // 진한 식물 그린
  static const _secondary = Color(0xFFB87333); // 테라코타(흙)
  static const _secondaryContainer = Color(0xFF8D5524); // 진한 테라코타
  static const _background = Color(0xFFF5F5DC); // 밝은 베이지
  static const _surface = Color(0xFFFFFFFF); // 흰색
  static const _error = Color(0xFFD32F2F); // 레드
  static const _onPrimary = Color(0xFFFFFFFF); // 흰색
  static const _onSecondary = Color(0xFFFFFFFF); // 흰색
  static const _onSurface = Color(0xFF4E342E); // 진한 브라운
  static const _onError = Color(0xFFFFFFFF); // 흰색

  static final ColorScheme colorScheme = ColorScheme(
    primary: _primary,
    primaryContainer: _primaryContainer,
    secondary: _secondary,
    secondaryContainer: _secondaryContainer,
    surface: _background,
    error: _error,
    onPrimary: _onPrimary,
    onSecondary: _onSecondary,
    onSurface: _onSurface,
    onError: _onError,
    brightness: Brightness.light,
  );

  static final ColorScheme darkScheme = ColorScheme(
    primary: _primary,
    primaryContainer: _primaryContainer,
    secondary: _secondary,
    secondaryContainer: _secondaryContainer,
    surface: _background,
    error: _error,
    onPrimary: _onPrimary,
    onSecondary: _onSecondary,
    onSurface: _onSurface,
    onError: _onError,
    brightness: Brightness.dark,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _secondaryContainer, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primary, width: 2),
        ),
        labelStyle: const TextStyle(color: _onSurface),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _secondary.withAlpha(10),
        selectedColor: _primary.withAlpha(20),
        labelStyle: const TextStyle(color: _onSurface),
        secondaryLabelStyle: const TextStyle(color: _onSecondary),
        disabledColor: Colors.grey[300],
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkScheme,
      scaffoldBackgroundColor: darkScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: darkScheme.surface,
        foregroundColor: darkScheme.onSurface,
      ),
    );
  }
} 