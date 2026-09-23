import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';

class ProjectHeader extends StatelessWidget {
  final ProjectInfo project;

  const ProjectHeader({required this.project});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: scheme.primary,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: AppTextStyles.greeting.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                '${project.members} integrantes',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${project.vacancies} vacantes',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Líder: ${project.leader}',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                project.area,
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
