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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),

      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : const Color.fromRGBO(226, 226, 226, 1),
      ),

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
              color: isDark ? Colors.amber : Colors.black87,
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
            color: isDark ? Colors.white : Colors.black87,
          ),

          const SizedBox(width: 15),

          Icon(
            Icons.person_outline,
            size: 28,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ],
      ),
    );
  }
}