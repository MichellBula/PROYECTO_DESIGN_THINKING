import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/profile/controllers/profile_controller.dart';
import 'package:uncampusconnet/features/profile/data/models/proyecto_participacion_model.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';

class ProfileProjects extends StatelessWidget {
  const ProfileProjects({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final proyectos = controller.proyectos;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proyectos en los que he participado:',
            style: AppTextStyles.sectionTitle.copyWith(
              color: scheme.onSurface,
            ),
          ),

          const SizedBox(height: 10),

          if (proyectos.isEmpty)
            CardWrapper(
              child: Text(
                'Todavía no has participado en proyectos.',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...proyectos.map(
              (p) => _ProyectoCard(proyecto: p),
            ),
        ],
      );
    });
  }
}

class _ProyectoCard extends StatelessWidget {
  final ProyectoParticipacion proyecto;

  const _ProyectoCard({required this.proyecto});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return CardWrapper(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: scheme.primary,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proyecto.nombre,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: scheme.onSurface,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  proyecto.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.smallText.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Rol: ${proyecto.rol.isEmpty ? "Sin rol" : proyecto.rol}',
                  style: AppTextStyles.smallText.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 8),

                _EstadoChip(estado: proyecto.estadoLabel),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoChip extends StatelessWidget {
  final String estado;

  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado,
        style: AppTextStyles.smallText.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}