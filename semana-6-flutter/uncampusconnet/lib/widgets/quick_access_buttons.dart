import 'package:flutter/material.dart';

class QuickAccessButtons extends StatelessWidget {
  const QuickAccessButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final defaultColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),

      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1E1E1E)
            : const Color.fromRGBO(250, 250, 250, 0.993),
      ),

      child: Row(
        children: [
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.home_outlined,
              label: 'Inicio',
              onTap: () {},
              color: const Color(0xFF9B0202),
            ),
          ),

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.search,
              label: 'Buscar',
              onTap: () {},
              color: defaultColor,
            ),
          ),

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.add_circle_outline,
              label: 'Crear',
              onTap: () {},
              color: defaultColor,
            ),
          ),

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.folder_open_outlined,
              label: 'Mis proyectos',
              onTap: () {},
              color: defaultColor,
            ),
          ),

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.chat_bubble_outline,
              label: 'Solicitudes',
              onTap: () {},
              color: defaultColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: color,
          ),

          const SizedBox(height: 5),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}