import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/information_box.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';
import 'package:uncampusconnet/features/create_proyect/widgets/confirmaction_button.dart';

class ConfirmarProyectoPage extends StatelessWidget {
  // ======================================================
  // DATOS BÁSICOS
  // ======================================================

  /// Nombre del proyecto.
  final String nombreProyecto;

  /// Descripción del proyecto.
  final String descripcion;

  /// Nombre del líder.
  final String liderProyecto;

  /// Categoría seleccionada.
  final String categoria;

  // ======================================================
  // DETALLES DEL PROYECTO
  // ======================================================

  /// Objetivo general.
  final String objetivo;

  /// Roles seleccionados.
  final List<String> roles;

  /// Cantidad de personas necesarias por rol.
  final Map<String, int> cantidadesPorRol;

  /// Habilidades seleccionadas.
  final List<String> habilidades;

  /// Requisitos del proyecto.
  final String requisitos;

  /// Tipo de proyecto.
  final String? tipoProyecto;

  /// Fecha de inicio.
  final DateTime? fechaInicio;

  /// Fecha de cierre.
  final DateTime? fechaCierre;

  /// Indica si se desea docente asesor.
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

  // ======================================================
  // FORMATO DE FECHA
  // ======================================================

  /// Convierte una fecha en formato dd / mm / yyyy.
  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) {
      return 'No seleccionada';
    }

    final String dia = fecha.day.toString().padLeft(2, '0');

    final String mes = fecha.month.toString().padLeft(2, '0');

    return '$dia / $mes / ${fecha.year}';
  }

  // ======================================================
  // PUBLICAR
  // ======================================================

  /// Crea el proyecto, lo agrega a la lista global
  /// y regresa a la pantalla inicial.
  void _publicarProyecto(BuildContext context) {
    final CreatedProjectInfo nuevoProyecto = CreatedProjectInfo(
      nombreProyecto: nombreProyecto,
      descripcion: descripcion,
      liderProyecto: liderProyecto,
      categoria: categoria,

      objetivo: objetivo,

      roles: List<String>.from(roles),

      cantidadesPorRol: Map<String, int>.from(cantidadesPorRol),

      habilidades: List<String>.from(habilidades),

      requisitos: requisitos,

      tipoProyecto: tipoProyecto,

      fechaInicio: fechaInicio,
      fechaCierre: fechaCierre,

      deseaDocente: deseaDocente,
    );

    // Guardar el proyecto.
    createdProjects.add(nuevoProyecto);

    // Mostrar información en la consola para pruebas.
    print('Proyecto publicado: $nombreProyecto');
    print('Total de proyectos: ${createdProjects.length}');

    // Regresar al inicio.
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

          children: [
            // ==================================================
            // TARJETA DE CONFIRMACIÓN
            // ==================================================

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),

                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,

                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),

                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.20),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      // ========================================
                      // TÍTULO
                      // ========================================

                      Text(
                        'Confirma tu información',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.screenTitle.copyWith(
                          color: scheme.onSurface,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Divider(color: scheme.outlineVariant),

                      const SizedBox(height: 12),

                      // ========================================
                      // DESCRIPCIÓN
                      // ========================================
                      Text(
                        'Asegúrate de que toda la información '
                        'esté correcta antes de publicar '
                        'el proyecto.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.smallText.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ========================================
                      // INFORMACIÓN IMPORTANTE
                      // ========================================
                      ImportantInfoBox(
                        textColor: scheme.onSurface,
                        secondaryColor: scheme.onSurfaceVariant,
                      ),

                      const SizedBox(height: 28),

                      // ========================================
                      // PREGUNTA
                      // ========================================
                      Text(
                        '¿Estás segur@ de publicar?',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ========================================
                      // BOTONES
                      // ========================================
                      Row(
                        children: [
                          // EDITAR
                          Expanded(
                            child: ConfirmationButton(
                              text: 'Editar',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          // PUBLICAR
                          Expanded(
                            child: ConfirmationButton(
                              text: 'Publicar',
                              onPressed: () {
                                _publicarProyecto(context);
                              },
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
