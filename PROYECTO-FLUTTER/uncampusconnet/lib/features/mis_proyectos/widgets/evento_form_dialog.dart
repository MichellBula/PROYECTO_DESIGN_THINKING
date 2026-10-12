import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/mis_proyectos/controllers/evento_controller.dart';
import 'package:uncampusconnet/ui/widgets/dropdown_field.dart';
import 'package:uncampusconnet/ui/widgets/text_field.dart';

Future<void> showEventoFormDialog(BuildContext context) async {
  final controller = Get.find<EventoController>();

  final nombreCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  String tipo = 'Reunión';
  DateTime? inicio;
  DateTime? fin;

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final scheme = Theme.of(context).colorScheme;

          return AlertDialog(
            title: const Text('Nuevo evento'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    label: 'Nombre',
                    hint: 'Nombre del evento',
                    controller: nombreCtrl,
                    maxLength: 60,
                  ),

                  const SizedBox(height: 12),

                  AppDropdownField(
                    label: 'Tipo',
                    hint: 'Selecciona un tipo',
                    value: tipo,
                    items: const [
                      'Reunión',
                      'Presentación',
                      'Entrega',
                      'Clase',
                      'Otro',
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => tipo = v);
                    },
                  ),

                  const SizedBox(height: 12),

                  AppTextField(
                    label: 'Descripción',
                    hint: 'Descripción del evento',
                    controller: descripcionCtrl,
                    maxLength: 300,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),

                  _FechaBoton(
                    texto: inicio == null
                        ? 'Fecha inicio'
                        : _fmt(inicio!),
                    onTap: () async {
                      final f = await _pickFechaHora(context, inicio);
                      if (f != null) setState(() => inicio = f);
                    },
                  ),

                  const SizedBox(height: 8),

                  _FechaBoton(
                    texto: fin == null ? 'Fecha fin' : _fmt(fin!),
                    onTap: () async {
                      final f = await _pickFechaHora(context, fin);
                      if (f != null) setState(() => fin = f);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                ),
                onPressed: () async {
                  if (nombreCtrl.text.trim().isEmpty ||
                      inicio == null ||
                      fin == null) {
                    return;
                  }

                  final ok = await controller.crearEvento(
                    nombre: nombreCtrl.text.trim(),
                    tipo: tipo,
                    descripcion: descripcionCtrl.text.trim(),
                    inicio: inicio!,
                    fin: fin!,
                  );

                  if (ok && dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

class _FechaBoton extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;

  const _FechaBoton({required this.texto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.calendar_today, size: 18),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            texto,
            style: TextStyle(color: scheme.onSurface),
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> _pickFechaHora(
  BuildContext context,
  DateTime? inicial,
) async {
  final hoy = DateTime.now();

  final fecha = await showDatePicker(
    context: context,
    initialDate: inicial ?? hoy,
    firstDate: DateTime(hoy.year - 1),
    lastDate: DateTime(hoy.year + 5),
  );

  if (fecha == null) return null;

  if (!context.mounted) return null;

  final hora = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(inicial ?? hoy),
  );

  if (hora == null) return null;

  return DateTime(
    fecha.year,
    fecha.month,
    fecha.day,
    hora.hour,
    hora.minute,
  );
}

String _fmt(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final hh = d.hour.toString().padLeft(2, '0');
  final mi = d.minute.toString().padLeft(2, '0');
  return '$dd/$mm $hh:$mi';
}