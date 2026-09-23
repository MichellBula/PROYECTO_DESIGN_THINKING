import 'package:flutter/material.dart';

import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';

Future<EtapaData?> showEtapaFormDialog(
  BuildContext context, {
  EtapaData? etapa,
}) async {
  final etiquetaController = TextEditingController(
    text: etapa?.etiqueta ?? '',
  );

  final descripcionController = TextEditingController(
    text: etapa?.descripcion ?? '',
  );

  final progresoController = TextEditingController(
    text: etapa == null
        ? ''
        : (etapa.progreso * 100).round().toString(),
  );

  final resultado = await showDialog<EtapaData>(
    context: context,
    builder: (dialogContext) {
      String? error;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              etapa == null
                  ? 'Crear nueva etapa'
                  : 'Editar etapa',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: etiquetaController,
                    decoration: const InputDecoration(
                      labelText: 'Etiqueta',
                      hintText: 'Ej. Prueba del simulador',
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: descripcionController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      hintText:
                          'Describe lo que se realizará en esta etapa',
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: progresoController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Progreso',
                      hintText: '0 - 100',
                      suffixText: '%',
                    ),
                  ),

                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancelar'),
              ),

              ElevatedButton(
                onPressed: () {
                  final etiqueta =
                      etiquetaController.text.trim();

                  final descripcion =
                      descripcionController.text.trim();

                  final porcentaje = double.tryParse(
                    progresoController.text
                        .trim()
                        .replaceAll(',', '.'),
                  );

                  if (etiqueta.isEmpty) {
                    setDialogState(() {
                      error =
                          'Escribe una etiqueta para la etapa.';
                    });
                    return;
                  }

                  if (descripcion.isEmpty) {
                    setDialogState(() {
                      error =
                          'Escribe una descripción para la etapa.';
                    });
                    return;
                  }

                  if (porcentaje == null ||
                      porcentaje < 0 ||
                      porcentaje > 100) {
                    setDialogState(() {
                      error =
                          'El progreso debe estar entre 0 y 100.';
                    });
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    EtapaData(
                      etiqueta: etiqueta,
                      descripcion: descripcion,
                      progreso: porcentaje / 100,
                      fechaFin: etapa?.fechaFin ??
                          DateTime.now().add(
                            const Duration(days: 30),
                          ),
                      avances: etapa?.avances ?? const [],
                    ),
                  );
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );

  etiquetaController.dispose();
  descripcionController.dispose();
  progresoController.dispose();

  return resultado;
}
