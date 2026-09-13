import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF121212)
            : const Color(0xFFF5F5F5),
      ),
    );
  }
}