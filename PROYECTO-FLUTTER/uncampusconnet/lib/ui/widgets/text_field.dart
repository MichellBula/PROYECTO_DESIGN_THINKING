import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';


class AppTextField extends StatelessWidget {
  /// Texto que identifica el campo.
  final String label;

  /// Texto que aparece cuando el campo está vacío.
  final String hint;

  /// Controlador encargado de leer y modificar el texto.
  final TextEditingController controller;

  /// Número máximo de caracteres permitidos.
  final int maxLength;

  /// Número máximo de líneas visibles.
  final int maxLines;

  /// Tipo de teclado que se mostrará.
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ETIQUETA
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(color: scheme.onSurface),
        ),

        const SizedBox(height: 6),

        // CAMPO DE TEXTO
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyText.copyWith(color: scheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.smallText.copyWith(
              color: scheme.onSurfaceVariant,
            ),

            filled: true,
            fillColor: scheme.surfaceContainerHighest,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),

            counterText: '',

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              borderSide: BorderSide(color: scheme.primary, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}