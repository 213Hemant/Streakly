import 'package:flutter/material.dart';

class AppTheme {
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Light Mode Colors
  static const _lightPrimary = Color(0xFF3B82F6);
  static const _lightOnPrimary = Colors.white;
  static const _lightBackground = Color(0xFFF9FAFB);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightOnSurface = Color(0xFF111827);
  static const _lightSecondary = Color(0xFFDBEAFE);
  static const _lightOnSecondary = Color(0xFF6B7280);

  // Dark Mode Colors
  static const _darkPrimary = Color(0xFF3B82F6);
  static const _darkOnPrimary = Colors.white;
  static const _darkBackground = Color(0xFF0F172A);
  static const _darkSurface = Color(0xFF1E293B);
  static const _darkOnSurface = Color(0xFFF9FAFB);
  static const _darkSecondary = Color(0xFF1E40AF);
  static const _darkOnSecondary = Color(0xFF9CA3AF);

  /// LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _lightPrimary,
      onPrimary: _lightOnPrimary,
      secondary: _lightSecondary,
      onSecondary: _lightOnSecondary,
      background: _lightBackground,
      surface: _lightSurface,
      onSurface: _lightOnSurface,
    ),
    fontFamily: 'Manrope',
    textTheme: _textTheme(_lightOnSurface, _lightOnSecondary),
    pageTransitionsTheme: _customTransitions,
    elevatedButtonTheme: _buttonTheme(_lightPrimary),
  );

  /// DARK THEME
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimary,
      onPrimary: _darkOnPrimary,
      secondary: _darkSecondary,
      onSecondary: _darkOnSecondary,
      background: _darkBackground,
      surface: _darkSurface,
      onSurface: _darkOnSurface,
    ),
    fontFamily: 'Manrope',
    textTheme: _textTheme(_darkOnSurface, _darkOnSecondary),
    pageTransitionsTheme: _customTransitions,
    elevatedButtonTheme: _buttonTheme(_darkPrimary),
  );

  /// Custom TextTheme for both light and dark themes.
  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: primary,
      ),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: primary,
      ),
    );
  }

  /// Custom PageTransitionsTheme for smooth fade, slide, and scale animations.
  static PageTransitionsTheme get _customTransitions {
    return PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _CustomPageTransitionBuilder(),
        TargetPlatform.iOS: _CustomPageTransitionBuilder(),
      },
    );
  }

  /// Elevated button styling
  static ElevatedButtonThemeData _buttonTheme(Color primaryColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}

/// Custom page transition that combines FadeTransition, SlideTransition, and ScaleTransition.
class _CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.1, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
