import 'package:flutter/material.dart';

import '../../../core/theme/text_styles.dart';
import '../domain/entities/profile.dart';
import '../../../ui/widgets/cards_wrapper.dart';

class ProfileStats extends StatelessWidget {
  final Profile profile;

  const ProfileStats({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    // =====================================================
    // VALORES A MOSTRAR
    // =====================================================

    final reputacion =
        profile.calificacionUsuario;

    final proyectos =
        profile.numeroProyectos;

    return CardWrapper(
      child: Row(
        children: [
          // =================================================
          // REPUTACION
          // =================================================

          Expanded(
            child: _StatItem(
              icon: Icons.star_rounded,
              value: reputacion != null
                  ? '${reputacion.toStringAsFixed(1)} / 5'
                  : '— / 5',
              label: 'Reputación',
              iconColor: scheme.primary,
            ),
          ),

          // =================================================
          // DIVISOR
          // =================================================

          Container(
            width: 1,
            height: 58,
            color: scheme.outlineVariant,
          ),

          // =================================================
          // PROYECTOS
          // =================================================

          Expanded(
            child: _StatItem(
              icon: Icons.folder_copy_outlined,
              value: proyectos != null
                  ? proyectos.toString()
                  : '0',
              label: 'Proyectos',
              iconColor: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// ITEM INDIVIDUAL
// =========================================================

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        // =================================================
        // ICONO
        // =================================================

        Icon(
          icon,
          size: 34,
          color: iconColor,
        ),

        const SizedBox(width: 10),

        // =================================================
        // TEXTO
        // =================================================

        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: AppTextStyles
                    .sectionTitle
                    .copyWith(
                  color: scheme.onSurface,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                label,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: AppTextStyles
                    .smallText
                    .copyWith(
                  color:
                      scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}