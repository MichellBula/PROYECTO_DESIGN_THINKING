import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/solicitud_card.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/cards_wrapper.dart';


class ProyectoSolicitudesCard extends StatefulWidget {
  final String proyecto;
  final List<Solicitud> solicitudes;

  const ProyectoSolicitudesCard({
    super.key,
    required this.proyecto,
    required this.solicitudes,
  });

  @override
  State<ProyectoSolicitudesCard> createState() =>
      _ProyectoSolicitudesCardState();
}

class _ProyectoSolicitudesCardState extends State<ProyectoSolicitudesCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ENCABEZADO
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 22,
                  color: scheme.primary,
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    widget.proyecto,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.solicitudes.length}',
                    style: AppTextStyles.smallText.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),

          // SOLICITUDES
          if (isExpanded) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 6),

            ...widget.solicitudes.map(
              (solicitud) => SolicitudTile(solicitud: solicitud),
            ),
          ],
        ],
      ),
    );
  }
}