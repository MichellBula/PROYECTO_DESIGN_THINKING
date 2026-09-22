import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const HeaderBanner({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),

      // Color del fondo: viene del surfaceContainer del tema
      color: scheme.surfaceContainer,

      child: Row(
        children: [
          Image.asset(
            'assets/images/logo_encabezado.png',
            height: 50,
          ),

          const Spacer(),

          // Botón de modo oscuro
          IconButton(
            onPressed: onThemeChanged,
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              size: 26,
              color: isDark ? Colors.amber : scheme.onSurface,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: isDark
                ? 'Cambiar a modo claro'
                : 'Cambiar a modo oscuro',
          ),

          const SizedBox(width: 15),

          Icon(
            Icons.notifications_none,
            size: 28,
            color: scheme.onSurface,
          ),

          const SizedBox(width: 15),

          Icon(
            Icons.person_outline,
            size: 28,
            color: scheme.onSurface,
          ),
        ],
      ),
    );
  }
}