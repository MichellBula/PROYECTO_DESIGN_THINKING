import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/mis_proyectos/controllers/evento_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/evento_detail_sheet.dart';

class CalendarioSemanal extends StatelessWidget {
  const CalendarioSemanal({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<EventoController>();

    return Obx(() {
      final base = controller.fechaActual.value;
      // lunes de la semana actual
      final lunes = base.subtract(Duration(days: base.weekday - 1));

      final dias = List.generate(7, (i) => lunes.add(Duration(days: i)));

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: dias.length,
        itemBuilder: (context, i) {
          final dia = dias[i];
          final eventos = controller.eventosDelDia(dia);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_diaSemana(dia.weekday)} ${dia.day}/${dia.month}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                if (eventos.isEmpty)
                  Text(
                    'Sin eventos',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  )
                else
                  ...eventos.map(
                    (e) => InkWell(
                      onTap: () => showEventoDetailSheet(context, [e]),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(Icons.circle,
                                size: 8, color: scheme.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e.nombre,
                                style:
                                    TextStyle(color: scheme.onSurface),
                              ),
                            ),
                            Text(
                              '${e.fechaInicio.hour.toString().padLeft(2, '0')}:'
                              '${e.fechaInicio.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }

  String _diaSemana(int d) {
    const nombres = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return nombres[d - 1];
  }
}