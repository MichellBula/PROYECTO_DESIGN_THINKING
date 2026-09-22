
import 'package:flutter/material.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

/// Muestra el mensaje informativo que indica que el usuario
/// será registrado como líder del proyecto.
class ImportantInfoBox extends StatelessWidget {
  final Color textColor;
  final Color secondaryColor;

  const ImportantInfoBox({
    required this.textColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 25,
            height: 25,

            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),

            child: Center(
              child: Text(
                'i',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          //Tetxo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Importante:',
                  style: AppTextStyles.smallText.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Tú serás el líder del proyecto.',
                  style: AppTextStyles.smallText.copyWith(
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

