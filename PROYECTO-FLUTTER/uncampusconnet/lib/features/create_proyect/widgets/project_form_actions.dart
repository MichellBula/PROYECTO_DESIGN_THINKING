import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';


class ProjectFormActions extends StatelessWidget {
  /// Acción ejecutada al cancelar el formulario.
  final VoidCallback onCancel;

  /// Acción ejecutada al continuar con el formulario.
  final VoidCallback onContinue;

  const ProjectFormActions({
    super.key,
    required this.onCancel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // BOTÓN CANCELAR
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.onSurface,
              side: BorderSide(color: scheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: const Text('Cancelar', style: AppTextStyles.buttonText),
          ),
        ),

        const SizedBox(width: 12),

        // BOTÓN CONTINUAR
        Expanded(
          child: ElevatedButton(
            onPressed: onContinue,
            child: const Text('Continuar', style: AppTextStyles.buttonText),
          ),
        ),
      ],
    );
  }
}
