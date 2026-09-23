import 'package:flutter/material.dart';

import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';
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
  final List<EtapaData> _etapas = [
    EtapaData(
      etiqueta: 'Creación del equipo',
      descripcion:
          'Organización inicial del equipo y asignación de responsabilidades.',
      progreso: 1.0,
      fechaFin: DateTime(2026, 8, 23),
      avances: [
        AvanceData(
          autor: 'Michell Bula',
          etiqueta: 'Creó nuevo evento',
          descripcion:
              'Se creó un nuevo evento para organizar las actividades.',
          fecha: DateTime(2026, 8, 23),
        ),
      ],
    ),
    EtapaData(
      etiqueta: 'Intento de simular ondas',
      descripcion:
          'Durante esta etapa el equipo se reunirá semanalmente para preparar las pruebas.',
      progreso: 0.05,
      fechaFin: DateTime(2026, 9, 5),
      avances: [
        AvanceData(
          autor: 'Michell Bula',
          etiqueta: 'Creó nuevo evento',
          descripcion:
              'Se creó un evento para coordinar las pruebas.',
          fecha: DateTime(2026, 8, 23),
        ),
        AvanceData(
          autor: 'Emanuel Siachoque',
          etiqueta: 'Adjuntó un .py',
          descripcion:
              'Se adjuntó el archivo de simulación.',
          fecha: DateTime(2026, 8, 22),
          archivos: const ['simulacion.py'],
        ),
      ],
    ),
  ];

  Future<void> _crearEtapa() async {
    final etapa = await showEtapaFormDialog(context);

    if (etapa != null && mounted) {
      setState(() => _etapas.add(etapa));
    }
  }

  Future<void> _editarEtapa(int index) async {
    final etapa = await showEtapaFormDialog(
      context,
      etapa: _etapas[index],
    );

    if (etapa != null && mounted) {
      setState(() => _etapas[index] = etapa);
    }
  }

  Future<void> _eliminarEtapa(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar etapa'),
        content: Text(
          '¿Deseas eliminar la Etapa #${index + 1}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      setState(() => _etapas.removeAt(index));
    }
  }

  void _verDetalles(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleEtapaPage(
          numero: index + 1,
          etapa: _etapas[index],
          onChanged: (etapa) {
            if (!mounted) return;

            setState(() {
              _etapas[index] = etapa;
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
                  _ProjectHeader(
                    project: widget.project,
                  ),
                  const SizedBox(height: 30),

                  ...List.generate(
                    _etapas.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 18,
                      ),
                      child: EtapaCard(
                        numero: index + 1,
                        etapa: _etapas[index],
                        onVerDetalles: () =>
                            _verDetalles(index),
                        onEditar: () =>
                            _editarEtapa(index),
                        onEliminar: () =>
                            _eliminarEtapa(index),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _crearEtapa,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      minimumSize:
                          const Size(double.infinity, 52),
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