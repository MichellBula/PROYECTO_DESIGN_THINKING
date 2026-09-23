import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/evento/controllers/evento_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class EventosProyectoPage extends StatefulWidget {
  final ProjectData project;

  const EventosProyectoPage({
    super.key,
    required this.project,
  });

  @override
  State<EventosProyectoPage> createState() => _EventosProyectoPageState();
}

class _EventosProyectoPageState extends State<EventosProyectoPage> {
  final controller = Get.put(EventoController());

  @override
  void initState() {
    super.initState();
    controller.cargarEventos(widget.project.idProyecto);
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
              title: 'Eventos del proyecto',
              onBack: () => Navigator.pop(context),
            ),

            Expanded(
              child: Obx(() {
                // Cargando
                if (controller.cargando.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                  children: [
                    // Nombre del proyecto
                    Text(
                      widget.project.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.formTitle.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Vacío o lista
                    if (controller.eventos.isEmpty)
                      const _EmptyEvents()
                    else
                      ...controller.eventos.map(
                        (evento) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _EventoCard(evento: evento),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

//Card evento
class _EventoCard extends StatelessWidget {
  final EventoUI evento;

  const _EventoCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return CardWrapper(
      padding: const EdgeInsets.all(18),
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

          // Etiqueta de tipo
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
              evento.tipo,
              style: AppTextStyles.smallText.copyWith(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Descripción
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

//Fila de fecha
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
        Icon(icon, size: 20, color: scheme.primary),
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
  const _EmptyEvents();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
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