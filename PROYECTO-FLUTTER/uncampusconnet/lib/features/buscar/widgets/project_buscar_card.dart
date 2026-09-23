import 'package:flutter/material.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';
import 'package:uncampusconnet/features/buscar/pages/proyecto_disponible_page.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';

class ProjectBuscarCard extends StatelessWidget {
  final ProjectInfo project;
  final bool isAvailable;

  const ProjectBuscarCard({
    super.key,
    required this.project,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final information = {
      'Líder': project.leader,
      'Nombre': project.name,
      'Integrantes': project.members,
      'Vacantes': project.vacancies,
      'Fecha cierre': project.closingDate,
    };

    return CardWrapper(
      padding: const EdgeInsets.all(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProyectoDisponiblePage(project: project),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...information.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodyText.copyWith(
                          color: scheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: '${entry.key}: ',
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                          TextSpan(
                            text: entry.value,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (!isAvailable) ...[
                  const SizedBox(height: 5),
                  Text(
                    'Convocatoria cerrada',
                    style: AppTextStyles.smallText.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
