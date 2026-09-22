import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';

/// Campo visual reutilizable para seleccionar una fecha.
class ProjectDateField extends StatelessWidget {
  /// Texto que identifica el campo.
  final String label;

  /// Fecha seleccionada.
  final DateTime? date;

  /// Acción ejecutada al tocar el campo.
  final VoidCallback onTap;

  const ProjectDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  /// Convierte la fecha a formato dd / mm / yyyy.
  String formatDate() {
    if (date == null) {
      return 'dd / mm / yyyy';
    }

    final String day = date!.day.toString().padLeft(2, '0');

    final String month = date!.month.toString().padLeft(2, '0');

    return '$day / $month / ${date!.year}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(color: scheme.onSurface),
        ),

        const SizedBox(height: 6),

        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.smallRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formatDate(),
                    style: AppTextStyles.smallText.copyWith(
                      color: date == null
                          ? scheme.onSurfaceVariant
                          : scheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: scheme.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
