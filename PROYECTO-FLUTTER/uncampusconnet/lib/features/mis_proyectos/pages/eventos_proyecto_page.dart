import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/controllers/evento_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/calendario_mensual.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/calendario_semanal.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/evento_form_dialog.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';
import 'package:uncampusconnet/ui/widgets/tab_selector.dart';

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
  final mainController = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
    controller.cargarEventos(widget.project.idProyecto);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            AppScreenTitle(
              title: 'Eventos del proyecto',
              onBack: () => mainController.closeEventos(),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Obx(
                () => AppTabSelector(
                  firstLabel: 'Semanal',
                  firstIcon: Icons.view_week_outlined,
                  secondLabel: 'Mensual',
                  secondIcon: Icons.calendar_month_outlined,
                  isFirstSelected: !controller.esMensual.value,
                  onChanged: (esSemanal) {
                    controller.cambiarVista(!esSemanal);
                  },
                ),
              ),
            ),

            Obx(() {
              final f = controller.fechaActual.value;
              final titulo = controller.esMensual.value
                  ? '${_mes(f.month)} ${f.year}'
                  : 'Semana del ${f.day}/${f.month}';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: controller.anterior,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        titulo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.siguiente,
                      icon: const Icon(Icons.chevron_right),
                    ),
                    TextButton(
                      onPressed: controller.irHoy,
                      child: const Text('Hoy'),
                    ),
                  ],
                ),
              );
            }),

            Expanded(
              child: Obx(() {
                if (controller.cargando.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return controller.esMensual.value
                    ? const CalendarioMensual()
                    : const CalendarioSemanal();
              }),
            ),
          ],
        ),

        // FAB abajo derecha
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton.extended(
            onPressed: () => showEventoFormDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Evento'),
          ),
        ),
      ],
    );
  }

  String _mes(int m) {
    const nombres = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return nombres[m - 1];
  }
}