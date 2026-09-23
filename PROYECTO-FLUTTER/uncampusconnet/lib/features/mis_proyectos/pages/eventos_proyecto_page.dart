import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/evento/domain/entities/evento.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class EventosProyectoPage extends StatelessWidget {
  final ProjectData project;

  const EventosProyectoPage({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Datos temporales para construir la interfaz.
    // Luego serán reemplazados por los eventos obtenidos desde Roble.
    final eventos = <Evento>[
      Evento(
        idProyecto: 1,
        nombre: 'Reunión de seguimiento',
        tipoEvento: 'Reunión',
        descripcion:
            'Revisión de los avances realizados y organización de las próximas tareas del proyecto.',
        fechaInicio: DateTime(2026, 9, 25, 15, 0),
        fechaFinal: DateTime(2026, 9, 25, 16, 0),
      ),
      Evento(
        idProyecto: 1,
        nombre: 'Prueba del proyecto',
        tipoEvento: 'Prueba',
        descripcion:
            'Prueba general de las funcionalidades desarrolladas por el equipo.',
        fechaInicio: DateTime(2026, 9, 29, 10, 0),
        fechaFinal: DateTime(2026, 9, 29, 11, 30),
      ),
    ];

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenTitle(
              title: 'Eventos del proyecto',
              onBack: () {
                Navigator.pop(context);
              },
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant,
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  30,
                ),
                children: [
                  Text(
                    project.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.formTitle.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (eventos.isEmpty)
                    _EmptyEvents(
                      projectTitle: project.title,
                    )
                  else
                    ...eventos.map(
                      (evento) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: _EventoCard(
                          evento: evento,
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

class _EventoCard extends StatelessWidget {
  final Evento evento;

  const _EventoCard({
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(
              alpha: 0.12,
            ),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            evento.nombre,
            style: AppTextStyles.cardTitle.copyWith(
              color: scheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              evento.tipoEvento,
              style: AppTextStyles.smallText.copyWith(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            evento.descripcion,
            style: AppTextStyles.bodyText.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 18),

          _DateRow(
            icon: Icons.play_circle_outline,
            label: 'Inicio',
            date: evento.fechaInicio,
          ),

          const SizedBox(height: 10),

          _DateRow(
            icon: Icons.stop_circle_outlined,
            label: 'Final',
            date: evento.fechaFinal,
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final DateTime date;

  const _DateRow({
    required this.icon,
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: scheme.primary,
        ),

        const SizedBox(width: 8),

        Text(
          '$label:',
          style: AppTextStyles.fieldLabel.copyWith(
            color: scheme.onSurface,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            _formatDateTime(date),
            style: AppTextStyles.smallText.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} - $hour:$minute';
  }
}

class _EmptyEvents extends StatelessWidget {
  final String projectTitle;

  const _EmptyEvents({
    required this.projectTitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 50,
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 48,
            color: scheme.onSurfaceVariant,
          ),

          const SizedBox(height: 14),

          Text(
            'Este proyecto todavía no tiene eventos.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
