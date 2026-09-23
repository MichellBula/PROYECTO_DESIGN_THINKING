import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

class AppTextField extends StatefulWidget {
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

  /// Si es un campo de contraseña (oculta el texto).
  final bool isPassword;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.isPassword = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ETIQUETA
        Text(
          widget.label,
          style: AppTextStyles.fieldLabel.copyWith(color: scheme.onSurface),
        ),

        const SizedBox(height: 6),

        // CAMPO DE TEXTO
        TextField(
          controller: widget.controller,
          maxLength: widget.maxLength,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && _obscure,
          style: AppTextStyles.bodyText.copyWith(color: scheme.onSurface),
          decoration: InputDecoration(
            hintText: widget.hint,
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

            // BOTÓN DE VER CONTRASEÑA
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: scheme.onSurfaceVariant,
                    ),
                  )
                : null,

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
