
import 'package:flutter/material.dart';

import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/models/etapas_local_store.dart';
import 'package:uncampusconnet/features/mis_proyectos/pages/detalle_etapa_page.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/etapa_card.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/etapa_form_dialog.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class AvancesPage extends StatefulWidget {
  final ProjectData project;

  const AvancesPage({
    super.key,
    required this.project,
  });

  @override
  State<AvancesPage> createState() => _AvancesPageState();
}

class _AvancesPageState extends State<AvancesPage> {
  late List<EtapaData> _etapas;

  @override
  void initState() {
    super.initState();
    _cargarEtapas();
  }

  void _cargarEtapas() {
    _etapas = EtapasLocalStore.obtenerEtapas(
      widget.project.idProyecto,
    );
  }

  @override
  void didUpdateWidget(covariant AvancesPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.project.idProyecto != widget.project.idProyecto) {
      _cargarEtapas();
    }
  }

  Future<void> _crearEtapa() async {
    final etapa = await showEtapaFormDialog(context);

    if (!mounted || etapa == null) return;

    setState(() {
      _etapas.add(etapa);
    });
  }

  Future<void> _editarEtapa(int index) async {
    if (index < 0 || index >= _etapas.length) return;

    final etapaOriginal = _etapas[index];

    final etapaEditada = await showEtapaFormDialog(
      context,
      etapa: etapaOriginal,
    );

    if (!mounted || etapaEditada == null) return;

    final posicionActual = _etapas.indexOf(etapaOriginal);

    if (posicionActual == -1) return;

    setState(() {
      _etapas[posicionActual] = etapaEditada;
    });
  }

  Future<void> _eliminarEtapa(int index) async {
    if (index < 0 || index >= _etapas.length) return;

    final etapaSeleccionada = _etapas[index];

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar etapa'),
        content: Text(
          '¿Deseas eliminar la Etapa #${index + 1}? '
          'También se eliminarán sus avances locales.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;

    final posicionActual = _etapas.indexOf(etapaSeleccionada);

    if (posicionActual == -1) return;

    setState(() {
      _etapas.removeAt(posicionActual);
    });
  }

  void _verDetalles(int index) {
    if (index < 0 || index >= _etapas.length) return;

    final etapaSeleccionada = _etapas[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleEtapaPage(
          numero: index + 1,
          etapa: etapaSeleccionada,
          onChanged: (etapaActualizada) {
            if (!mounted) return;

            final posicionActual = _etapas.indexOf(
              etapaSeleccionada,
            );

            if (posicionActual == -1) return;

            setState(() {
              _etapas[posicionActual] = etapaActualizada;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenTitle(
              title: 'Avances',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _ProjectHeader(project: widget.project),

                  const SizedBox(height: 30),

                  if (_etapas.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.layers_outlined,
                              size: 55,
                              color: scheme.primary,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Este proyecto aún no tiene etapas.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Crea una etapa para comenzar a registrar avances.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                  ...List.generate(
                    _etapas.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 18,
                      ),
                      child: EtapaCard(
                        numero: index + 1,
                        etapa: _etapas[index],
                        onVerDetalles: () => _verDetalles(index),
                        onEditar: () => _editarEtapa(index),
                        onEliminar: () => _eliminarEtapa(index),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _crearEtapa,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      minimumSize: const Size(
                        double.infinity,
                        52,
                      ),
                    ),
                    child: const Text(
                      'Crear Etapa nueva',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  final ProjectData project;

  const _ProjectHeader({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 58,
          backgroundColor: scheme.primary,
          child: Icon(
            Icons.graphic_eq,
            size: 55,
            color: scheme.onPrimary,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${project.membersCount} integrantes'),
              Text('${project.vacancies} vacantes'),
              Text('Líder: ${project.leader}'),
              Text(
                project.category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
