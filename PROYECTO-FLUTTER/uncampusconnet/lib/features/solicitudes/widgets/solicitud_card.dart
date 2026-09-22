import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';


class SolicitudTile extends StatelessWidget {
  final Solicitud solicitud;

  const SolicitudTile({
    super.key,
    required this.solicitud,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      // AL TOCAR → abre el detalle de la solicitud
      onTap: () {
        final controller = Get.find<MainController>();
        controller.openSolicitudDetalle(solicitud);
      },
      behavior: HitTestBehavior.opaque,

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            // AVATAR
            CircleAvatar(
              radius: 18,
              backgroundColor: scheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                size: 20,
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
                    solicitud.nombre,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Quiere ser: ${solicitud.cargo}',
                    style: AppTextStyles.caption.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // FLECHA (indica que es clickeable)
            Icon(
              Icons.chevron_right,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}