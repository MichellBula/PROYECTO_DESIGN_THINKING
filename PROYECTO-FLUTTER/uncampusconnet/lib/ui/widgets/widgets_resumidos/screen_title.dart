import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';

/// Título reutilizable para las pantallas de la aplicación.
///
/// Permite mostrar un título centrado y opcionalmente
/// un botón para regresar a la pantalla anterior.
class AppScreenTitle extends StatelessWidget {
  /// Texto que se mostrará como título.
  final String title;

  /// Indica si se debe mostrar el botón de regresar.
  final bool showBackButton;

  /// Función que se ejecuta al presionar el botón de regresar.
  ///
  /// Si no se proporciona, se utiliza Navigator.pop().
  final VoidCallback? onBack;

  const AppScreenTitle({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 52,

      child: Row(
        children: [
          // BOTÓN ATRÁS

          if (showBackButton)
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,

              child: Icon(
                Icons.chevron_left,
                size: 28,
                color: scheme.onSurface,
              ),
            )
          else
            const SizedBox(width: 28),

          // TÍTULO
          Expanded(
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.screenTitle.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
          ),

          // ESPACIO PARA CENTRAR EL TÍTULO
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}
