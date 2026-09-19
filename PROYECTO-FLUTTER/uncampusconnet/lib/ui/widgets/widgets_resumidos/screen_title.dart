import 'package:flutter/material.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';

class AppScreenTitle extends StatelessWidget {
  /// Texto del título
  final String title;
  /// Muestra el botón de atrás (chevron izquierdo)
  final bool showBackButton;

  const AppScreenTitle({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 52,
      child: Row(
        children: [
          //Botón atrás
          if (showBackButton)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.chevron_left,
                size: 28,
                color: scheme.onSurface,
              ),
            )
          else
            const SizedBox(width: 28),

          //Título
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

          //Centrado
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}