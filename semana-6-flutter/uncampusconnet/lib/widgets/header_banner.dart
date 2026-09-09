import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {
  const HeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),

      decoration: BoxDecoration(
        color: isDarkMode
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

          Icon(
            Icons.notifications_none,
            size: 28,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),

          const SizedBox(width: 15),

          Icon(
            Icons.person_outline,
            size: 28,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ],
      ),
    );
  }
}