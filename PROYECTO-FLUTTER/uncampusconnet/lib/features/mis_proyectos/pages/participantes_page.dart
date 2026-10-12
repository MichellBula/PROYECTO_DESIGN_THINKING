import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/integrantes/controllers/integrante_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class ParticipantesPage extends StatefulWidget {
  final ProjectData project;

  const ParticipantesPage({
    super.key,
    required this.project,
  });

  @override
  State<ParticipantesPage> createState() => _ParticipantesPageState();
}

class _ParticipantesPageState extends State<ParticipantesPage> {
  final controller = Get.put(IntegranteController());
  final mainController = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
    controller.cargarParticipantes(widget.project.idProyecto);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // TÍTULO
        AppScreenTitle(
          title: 'Lista de participantes',
          onBack: () {
            mainController.closeParticipantes();
          },
        ),

        // CONTENIDO
        Expanded(
          child: Obx(() {
            // CARGANDO
            if (controller.cargando.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // VACÍO
            if (controller.participantes.isEmpty) {
              return Center(
                child: Text(
                  'No hay participantes.',
                  style: AppTextStyles.bodyText.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            // CON DATOS
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
              children: [
                Text(
                  widget.project.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.formTitle.copyWith(
                    color: scheme.onSurface,
                  ),
                ),

                const SizedBox(height: 34),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Usuario',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Rol',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ...controller.participantes.map(
                  (participante) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _ParticipantBox(
                            text: participante.usuario,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ParticipantBox(
                            text: participante.rol,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _ParticipantBox extends StatelessWidget {
  final String text;

  const _ParticipantBox({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 48,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyText.copyWith(
          color: scheme.onSurface,
        ),
      ),
    );
  }
}