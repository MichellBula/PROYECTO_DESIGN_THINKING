import 'package:flutter/material.dart';

import 'package:uncampusconnet/features/mis_proyectos/data/evento_data.dart';

void showEventoDetailSheet(
  BuildContext context,
  List<EventoData> eventos,
) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) {
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: eventos.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(e.tipoEvento),
                  const SizedBox(height: 4),
                  Text(e.descripcion),
                  const SizedBox(height: 4),
                  Text(
                    '${_fmt(e.fechaInicio)} — ${_fmt(e.fechaFinal)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Divider(),
                ],
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}

String _fmt(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final hh = d.hour.toString().padLeft(2, '0');
  final mi = d.minute.toString().padLeft(2, '0');
  return '$dd/$mm $hh:$mi';
}