import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/information_box.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/confirmaction_button.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';

class ConfirmarProyectoPage extends StatelessWidget {
  final String nombreProyecto;
  final String descripcion;
  final String liderProyecto;
  final String categoria;
  final String objetivo;
  final List<String> roles;
  final Map<String, int> cantidadesPorRol;
  final List<String> habilidades;
  final String requisitos;
  final String? tipoProyecto;
  final DateTime? fechaInicio;
  final DateTime? fechaCierre;
  final bool deseaDocente;

  const ConfirmarProyectoPage({
    super.key,
    required this.nombreProyecto,
    required this.descripcion,
    required this.liderProyecto,
    required this.categoria,
    required this.objetivo,
    required this.roles,
    required this.cantidadesPorRol,
    required this.habilidades,
    required this.requisitos,
    required this.tipoProyecto,
    required this.fechaInicio,
    required this.fechaCierre,
    required this.deseaDocente,
  });

  void _publicarProyecto(BuildContext context) {
    createdProjects.add(
      CreatedProjectInfo(
        nombreProyecto: nombreProyecto,
        descripcion: descripcion,
        liderProyecto: liderProyecto,
        categoria: categoria,
        objetivo: objetivo,
        roles: List.from(roles),
        cantidadesPorRol: Map.from(cantidadesPorRol),
        habilidades: List.from(habilidades),
        requisitos: requisitos,
        tipoProyecto: tipoProyecto,
        fechaInicio: fechaInicio,
        fechaCierre: fechaCierre,
        deseaDocente: deseaDocente,
      ),
    );

    debugPrint('Proyecto publicado: $nombreProyecto');
    debugPrint('Total de proyectos: ${createdProjects.length}');

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius:
                        BorderRadius.circular(AppTheme.cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.20),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Confirma tu información',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.screenTitle.copyWith(
                          color: scheme.onSurface,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Divider(
                        color: scheme.outlineVariant,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Asegúrate de que toda la información '
                        'esté correcta antes de publicar el proyecto.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.smallText.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ImportantInfoBox(
                        textColor: scheme.onSurface,
                        secondaryColor: scheme.onSurfaceVariant,
                      ),

                      const SizedBox(height: 28),

                      Text(
                        '¿Estás segur@ de publicar?',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: ConfirmationButton(
                              text: 'Editar',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ConfirmationButton(
                              text: 'Publicar',
                              onPressed: () =>
                                  _publicarProyecto(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}