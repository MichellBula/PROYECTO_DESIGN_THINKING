import 'package:flutter/material.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';

/// Título reutilizable para las pantallas de la aplicación.
///
/// Puede mostrar un botón de regreso y permite definir
/// una acción personalizada mediante [onBack].
class AppScreenTitle extends StatelessWidget {
  final String title;
  final bool showBackButton;
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

          const SizedBox(width: 28),
        ],
      ),
    );
  }
}
