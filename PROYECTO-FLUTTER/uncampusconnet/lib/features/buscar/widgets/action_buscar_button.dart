import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';
import 'package:uncampusconnet/features/buscar/pages/completar_solicitud_page.dart';

class ActionBuscarButton extends StatelessWidget {
  final ProjectInfo project;
  final bool isAvailable;

  const ActionBuscarButton({required this.project, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (!isAvailable) {
      return Container(
        width: double.infinity,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        ),
        child: Text(
          'Convocatoria cerrada',
          style: AppTextStyles.buttonText.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompletarSolicitudPage(project: project),
            ),
          );
        },
        child: const Text('Postularse'),
      ),
    );
  }
}
