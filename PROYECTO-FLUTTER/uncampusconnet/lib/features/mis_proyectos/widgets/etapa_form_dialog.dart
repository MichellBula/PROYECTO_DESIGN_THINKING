
import 'package:flutter/material.dart';

import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';

Future<EtapaData?> showEtapaFormDialog(
  BuildContext context, {
  EtapaData? etapa,
}) {
  return showDialog<EtapaData>(
    context: context,
    builder: (dialogContext) {
      return _EtapaFormDialog(etapa: etapa);
    },
  );
}

class _EtapaFormDialog extends StatefulWidget {
  final EtapaData? etapa;

  const _EtapaFormDialog({
    this.etapa,
  });

  @override
  State<_EtapaFormDialog> createState() =>
      _EtapaFormDialogState();
}

class _EtapaFormDialogState extends State<_EtapaFormDialog> {
  late final TextEditingController _etiquetaController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _progresoController;

  String? _error;

  @override
  void initState() {
    super.initState();

    _etiquetaController = TextEditingController(
      text: widget.etapa?.etiqueta ?? '',
    );

    _descripcionController = TextEditingController(
      text: widget.etapa?.descripcion ?? '',
    );

    _progresoController = TextEditingController(
      text: widget.etapa == null
          ? ''
          : (widget.etapa!.progreso * 100).round().toString(),
    );
  }

  @override
  void dispose() {
    _etiquetaController.dispose();
    _descripcionController.dispose();
    _progresoController.dispose();

    super.dispose();
  }

  void _guardar() {
    final etiqueta = _etiquetaController.text.trim();
    final descripcion = _descripcionController.text.trim();

    final porcentaje = double.tryParse(
      _progresoController.text.trim().replaceAll(',', '.'),
    );

    if (etiqueta.isEmpty) {
      setState(() {
        _error = 'Escribe una etiqueta para la etapa.';
      });
      return;
    }

    if (descripcion.isEmpty) {
      setState(() {
        _error = 'Escribe una descripción para la etapa.';
      });
      return;
    }

    if (porcentaje == null ||
        porcentaje < 0 ||
        porcentaje > 100) {
      setState(() {
        _error = 'El progreso debe estar entre 0 y 100.';
      });
      return;
    }

    final nuevaEtapa = EtapaData(
      etiqueta: etiqueta,
      descripcion: descripcion,
      progreso: porcentaje / 100,
      fechaFin: widget.etapa?.fechaFin ??
          DateTime.now().add(
            const Duration(days: 30),
          ),
      avances: widget.etapa?.avances ?? const [],
    );

    Navigator.of(context).pop(nuevaEtapa);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        widget.etapa == null
            ? 'Crear nueva etapa'
            : 'Editar etapa',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _etiquetaController,
              decoration: const InputDecoration(
                labelText: 'Etiqueta',
                hintText: 'Ej. Prueba del simulador',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _descripcionController,
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
              controller: _progresoController,
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

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(
                  color: scheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),

        ElevatedButton(
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
