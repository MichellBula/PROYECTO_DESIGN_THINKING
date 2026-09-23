import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';

class EtapaCard extends StatelessWidget {
  final int numero;
  final EtapaData etapa;
  final VoidCallback onVerDetalles;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const EtapaCard({
    super.key,
    required this.numero,
    required this.etapa,
    required this.onVerDetalles,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final porcentaje = (etapa.progreso * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flag_outlined,
              color: scheme.onPrimary,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Etapa #$numero',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Etiqueta: ${etapa.etiqueta}',
                  style: AppTextStyles.bodyText.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Progreso:',
                  style: AppTextStyles.bodyText.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: etapa.progreso,
                          minHeight: 9,
                          backgroundColor:
                              scheme.surfaceContainerHighest,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$porcentaje%',
                      style: AppTextStyles.bodyText.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'detalles':
                  onVerDetalles();
                  break;
                case 'editar':
                  onEditar();
                  break;
                case 'eliminar':
                  onEliminar();
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'detalles',
                child: Row(
                  children: [
                    Icon(Icons.visibility_outlined),
                    SizedBox(width: 10),
                    Text('Ver detalles'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 10),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'eliminar',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 10),
                    Text('Eliminar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}