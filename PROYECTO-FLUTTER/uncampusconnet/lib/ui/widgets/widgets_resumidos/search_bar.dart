import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';


class AppSearchBar extends StatelessWidget {
  /// Texto que se muestra cuando está vacío
  final String hintText;

  /// Función que se ejecuta al presionar "Enter" o tocar el icono
  final ValueChanged<String>? onSubmitted;

  /// Función que se ejecuta al tocar el icono de la derecha
  final VoidCallback? onSuffixTap;

  /// Controlador del campo
  final TextEditingController? controller;

  /// Icono a la derecha 
  final IconData suffixIcon;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.onSubmitted,
    this.onSuffixTap,
    this.controller,
    this.suffixIcon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.smallText.copyWith(color: scheme.onSurface),
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.smallText.copyWith(
            color: scheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          suffixIcon: IconButton(
            onPressed: onSuffixTap,
            icon: Icon(
              suffixIcon,
              size: 25,
              color: scheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}