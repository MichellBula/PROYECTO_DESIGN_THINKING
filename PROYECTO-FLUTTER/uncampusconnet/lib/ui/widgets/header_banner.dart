import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;
  final VoidCallback onProfileTap;

  const HeaderBanner({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onProfileTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final scheme =
        theme.colorScheme;

    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      color:
          scheme.surfaceContainer,
      child: Row(
        children: [
          // =================================================
          // LOGO
          // =================================================

          Image.asset(
            'assets/images/logo_encabezado.png',
            height: 50,
          ),

          const Spacer(),

          // =================================================
          // MODO OSCURO
          // =================================================

          IconButton(
            onPressed:
                onThemeChanged,
            icon: Icon(
              isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              size: 26,
              color: isDark
                  ? Colors.amber
                  : scheme.onSurface,
            ),
            padding:
                EdgeInsets.zero,
            constraints:
                const BoxConstraints(),
            tooltip: isDark
                ? 'Cambiar a modo claro'
                : 'Cambiar a modo oscuro',
          ),

          const SizedBox(
            width: 15,
          ),

          // =================================================
          // NOTIFICACIONES
          // =================================================

          Icon(
            Icons.notifications_none,
            size: 28,
            color:
                scheme.onSurface,
          ),

          const SizedBox(
            width: 15,
          ),

          // =================================================
          // PERFIL
          // =================================================

          IconButton(
            onPressed:
                onProfileTap,
            icon: Icon(
              Icons.person_outline,
              size: 28,
              color:
                  scheme.onSurface,
            ),
            tooltip:
                'Mi perfil',
            padding:
                EdgeInsets.zero,
            constraints:
                const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}