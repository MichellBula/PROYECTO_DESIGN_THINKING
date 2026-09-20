import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

/// Selector reutilizable para indicar si el proyecto
/// necesita un docente asesor.
///
/// Solo uno de los estados puede estar seleccionado:
/// Sí o No.
class AdvisorToggle extends StatelessWidget {
  /// Estado actual.
  ///
  /// `true` representa "Sí".
  /// `false` representa "No".
  final bool wantsAdvisor;

  /// Acción cuando el usuario selecciona "Sí".
  final VoidCallback onYes;

  /// Acción cuando el usuario selecciona "No".
  final VoidCallback onNo;

  const AdvisorToggle({
    super.key,
    required this.wantsAdvisor,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            '¿Desea docente asesor?',
            style: AppTextStyles.fieldLabel.copyWith(color: scheme.onSurface),
          ),
        ),

        _buildButton(context, text: 'Sí', selected: wantsAdvisor, onTap: onYes),

        const SizedBox(width: 10),

        _buildButton(context, text: 'No', selected: !wantsAdvisor, onTap: onNo),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 34,
        decoration: BoxDecoration(
          color: selected ? scheme.primary : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.navLabel.copyWith(
              color: selected ? scheme.onPrimary : scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
