import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';

class AppButton extends StatelessWidget {
  /// Texto del botón
  final String text;

  /// Acción al presionar
  final VoidCallback onPressed;

  /// Icono opcional (a la izquierda del texto)
  final IconData? icon;

  /// Si ocupa todo el ancho disponible
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(text, style: AppTextStyles.buttonText),
              ],
            )
          : Text(text, style: AppTextStyles.buttonText),
    );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: button,
      );
    }

    return button;
  }
}