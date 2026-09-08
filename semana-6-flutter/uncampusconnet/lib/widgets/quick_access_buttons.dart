import 'package:flutter/material.dart';

class QuickAccessButtons extends StatelessWidget {
  const QuickAccessButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),

      decoration: BoxDecoration(
        color: Color.fromRGBO(250, 250, 250, 0.993),
        // borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.home_outlined,
              label: 'Inicio',
              onTap: () {},
              color:  const Color(0xFF9b0202), // Set the color to blue
            ),
          ),
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.search,
              label: 'Buscar',
              onTap: () {},
              color: Colors.black, // Set the color to blue
            ),
          ),
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.add_circle_outline,
              label: 'Crear',
              onTap: () {},
              color: Color.fromARGB(255, 2, 2, 2), // Set the color to blue
            ),
          ),
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.folder_open_outlined,
              label: 'Mis proyectos',
              onTap: () {},
              color: Colors.black, // Set the color to blue
            ),
          ),
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.chat_bubble_outline,
              label: 'Solicitudes',
              onTap: () {},
              color: Colors.black, // Set the color to blue
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
  final Color color; // Color of the icon and text

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color, // Default color is black
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
