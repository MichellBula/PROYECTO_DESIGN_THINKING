import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/cards_wrapper.dart';


class SolicitudSimpleCard extends StatelessWidget {
  final Solicitud solicitud;

  const SolicitudSimpleCard({
    super.key,
    required this.solicitud,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return CardWrapper(
      child: Row(
        children: [
          // ICONO
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.send_outlined,
              size: 22,
              color: scheme.primary,
            ),
          ),

          const SizedBox(width: 12),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  solicitud.proyecto,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Postulaste a: ${solicitud.cargo}',
                  style: AppTextStyles.caption.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // ESTADO
          Icon(
            Icons.schedule_outlined,
            size: 22,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}