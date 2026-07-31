import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ─── Couleurs principales ───────────────────────────────
  static const Color _primaryDark = Color(0xFF1A1A2E);
  static const Color _accentCyan = Color(0xFF00D2FF);
  static const Color _accentTeal = Color(0xFF53F0CE);
  static const Color _surfaceDark = Color(0xFF1E1E30);
  static const Color _cardDark = Color(0xFF252540);
  static const Color _textPrimary = Color(0xFFF0F0F5);
  static const Color _textSecondary = Color(0xFFB0B0C8);
  static const Color _errorRed = Color(0xFFFF6B6B);
  static const Color _successGreen = Color(0xFF51CF66);

  // ─── Theme Data ─────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: _accentCyan,
        secondary: _accentTeal,
        surface: _surfaceDark,
        error: _errorRed,
        onPrimary: _primaryDark,
        onSecondary: _primaryDark,
        onSurface: _textPrimary,
        onError: Colors.white,
      ),

      // ── AppBar ──
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: _textPrimary,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: _accentCyan),
      ),

      // ── Cards ──
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      // ── Input (Search bar) ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardDark.withValues(alpha: 0.8),
        hintStyle: const TextStyle(
          color: _textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIconColor: _accentCyan,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _accentCyan.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _accentCyan, width: 1.5),
        ),
      ),

      // ── Text ──
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: _textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _textSecondary,
        ),
        labelMedium: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _textSecondary,
          letterSpacing: 0.8,
        ),
      ),

      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: _accentCyan.withValues(alpha: 0.08),
        thickness: 1,
      ),

      // ── ProgressIndicator ──
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _accentCyan,
      ),
    );
  }

  // ─── Couleurs accessibles en statique ───────────────────
  static Color get accentCyan => _accentCyan;
  static Color get accentTeal => _accentTeal;
  static Color get cardColor => _cardDark;
  static Color get textSecondary => _textSecondary;
  static Color get errorRed => _errorRed;
  static Color get successGreen => _successGreen;
  static Color get primaryDark => _primaryDark;
}
