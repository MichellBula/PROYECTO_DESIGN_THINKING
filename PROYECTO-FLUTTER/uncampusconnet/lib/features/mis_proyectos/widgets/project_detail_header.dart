import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';

/// Cabecera del detalle de un proyecto.
///
/// Muestra la imagen representativa del proyecto, su nombre,
/// el líder, la cantidad de integrantes y las vacantes disponibles.
class ProjectDetailHeader extends StatelessWidget {
  /// Proyecto que se está mostrando.
  final ProjectData project;

  const ProjectDetailHeader({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================
          // IMAGEN DEL PROYECTO
          // ==================================================

          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.folder_outlined,
              size: 38,
              color: scheme.onPrimary,
            ),
          ),

          const SizedBox(width: 16),

          // ==================================================
          // INFORMACIÓN
          // ==================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text(
                  project.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: scheme.onSurface,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                // Líder
                Text(
                  'Líder: ${project.leader}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.smallText.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 4),

                // Integrantes
                Text(
                  'Integrantes: ${project.membersCount}',
                  style: AppTextStyles.smallText.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 4),

                // Vacantes
                Text(
                  'Vacantes: ${project.vacancies}',
                  style: AppTextStyles.smallText.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                // tipo de proyecto
                Text(
                  '${project.category}',
                  style: AppTextStyles.smallText.copyWith(
                    color: scheme.onSurfaceVariant,
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
