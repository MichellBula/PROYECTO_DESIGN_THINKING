import 'package:flutter/material.dart';

class AppTheme {
  //Colores base
  static const seed = Color(0xFF931212);
  static const primaryRed = Color(0xFF931212);
  static const darkRed = Color(0xFF941818);
  static const buttonRed = Color(0xFF500000);
  static const meetingRed = Color(0xFF6B0F0F);

  //Radios
  static const cardRadius = 16.0;
  static const eventCardRadius = 14.0;
  static const smallRadius = 8.0;
  static const iconRadius = 6.0;

  //Temas
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;

    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    ).copyWith(
      primary: buttonRed,
      onPrimary: Colors.white,

      // Fondos planos (sin tinte rosa)
      surface: isLight ? const Color(0xFFF5F5F5) : const Color(0xFF121212),
      surfaceContainer: isLight
          ? const Color(0xFFE2E2E2)
          : const Color(0xFF1E1E1E),
      surfaceContainerHighest: isLight
          ? const Color(0xFFE2E2E2)
          : const Color(0xFF2A2A2A),
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,

      //Fondo
      scaffoldBackgroundColor: isLight
          ? const Color(0xFFF5F5F5)
          : scheme.surface,

      //App bar
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),

      //Linea divisoria
      dividerTheme: DividerThemeData(
        color: isLight ? const Color(0xFFE2E2E2) : const Color(0xFF333333),
        thickness: 1,
        space: 1,
      ),

      //Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonRed,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      //Cards
      cardTheme: CardThemeData(
        color: isLight ? Colors.white : const Color(0xFF1E1E1E),
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: scheme.shadow.withValues(alpha: 0.10),
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),

      //Tipografias
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: scheme.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: scheme.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: scheme.onPrimary,
        ),
      ),
    );
  }
}