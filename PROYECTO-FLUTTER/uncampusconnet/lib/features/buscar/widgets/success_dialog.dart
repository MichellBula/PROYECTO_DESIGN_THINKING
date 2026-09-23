import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

class SuccessDialog extends StatelessWidget {
  final String projectName;
  final VoidCallback onClose;

  const SuccessDialog({required this.projectName, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 70,
                color: scheme.onPrimary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              '¡Tu solicitud fue enviada\ncon éxito!',
              textAlign: TextAlign.center,
              style: AppTextStyles.formTitle.copyWith(color: scheme.onSurface),
            ),

            const SizedBox(height: 10),

            Text(
              'Tu postulación a $projectName fue registrada.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Está atent@ a tus notificaciones para '
              'conocer los cambios en tu solicitud.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onClose,
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
