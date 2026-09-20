import 'package:flutter/material.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

// ======================================================
// BOTÓN DE CONFIRMACIÓN
// ======================================================

/// Botón reutilizable para las acciones de la pantalla
/// de confirmación.
///
/// Utiliza [Expanded] desde el padre para que los botones
/// tengan exactamente el mismo ancho.

class ConfirmationButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ConfirmationButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.smallRadius),
          ),

          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),

        child: Text(
          text,

          // Evita que el texto se divida en dos líneas.
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,

          textAlign: TextAlign.center,

          style: AppTextStyles.buttonText.copyWith(color: scheme.onPrimary),
        ),
      ),
    );
  }
}
