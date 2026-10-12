import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/mis_proyectos/controllers/evento_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/evento_detail_sheet.dart';

class CalendarioMensual extends StatelessWidget {
  const CalendarioMensual({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<EventoController>();

    return Obx(() {
      final base = controller.fechaActual.value;
      final primerDia = DateTime(base.year, base.month, 1);
      final diasEnMes = DateTime(base.year, base.month + 1, 0).day;
      final offset = primerDia.weekday - 1; // lunes = 0
      final total = offset + diasEnMes;

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            // Encabezado Lun..Dom
            Row(
              children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 8),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: total,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                if (index < offset) {
                  return const SizedBox.shrink();
                }

                final dia = index - offset + 1;
                final fecha = DateTime(base.year, base.month, dia);
                final eventos = controller.eventosDelDia(fecha);
                final hoy = _esHoy(fecha);

                return InkWell(
                  onTap: eventos.isEmpty
                      ? null
                      : () => showEventoDetailSheet(context, eventos),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: hoy
                          ? scheme.primaryContainer
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dia',
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontWeight:
                                hoy ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (eventos.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  bool _esHoy(DateTime f) {
    final hoy = DateTime.now();
    return f.year == hoy.year && f.month == hoy.month && f.day == hoy.day;
  }
}