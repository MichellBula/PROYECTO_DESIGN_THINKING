import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/information_list.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);

// ======================================================
// PÁGINA CONFIRMAR PROYECTO
// ======================================================

class ConfirmarProyectoPage extends StatelessWidget {
  // ====================================================
  // DATOS DE LA PRIMERA PANTALLA
  // ====================================================

  final String nombreProyecto;
  final String descripcion;
  final String liderProyecto;
  final String categoria;

  // ====================================================
  // DATOS DE DETALLES DEL PROYECTO
  // ====================================================

  final String objetivo;
  final List<String> roles;
  final Map<String, int> cantidadesPorRol;
  final List<String> habilidades;
  final String requisitos;
  final String? tipoProyecto;

  // ====================================================
  // FECHAS
  // ====================================================

  final DateTime? fechaInicio;
  final DateTime? fechaCierre;

  // ====================================================
  // DOCENTE
  // ====================================================

  final bool deseaDocente;

  // ====================================================
  // CONSTRUCTOR
  // ====================================================

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

  // ====================================================
  // FORMATEAR FECHA
  // ====================================================

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) {
      return 'No seleccionada';
    }

    final String dia =
        fecha.day.toString().padLeft(2, '0');

    final String mes =
        fecha.month.toString().padLeft(2, '0');

    final String anio =
        fecha.year.toString();

    return '$dia / $mes / $anio';
  }

  // ====================================================
  // IMPRIMIR UN PROYECTO
  // ====================================================

  void _imprimirProyecto(
    CreatedProjectInfo proyecto,
    int numeroProyecto,
  ) {
    print('');
    print('==================================================');
    print('PROYECTO $numeroProyecto');
    print('==================================================');

    print('Nombre: ${proyecto.nombreProyecto}');
    print('Descripción: ${proyecto.descripcion}');
    print('Líder: ${proyecto.liderProyecto}');
    print('Categoría: ${proyecto.categoria}');

    print('');
    print('--- INFORMACIÓN GENERAL ---');

    print('Objetivo: ${proyecto.objetivo}');

    print('Roles:');

    if (proyecto.roles.isEmpty) {
      print('  Ninguno');
    } else {
      for (final String role in proyecto.roles) {
        print(
          '  - $role: '
          '${proyecto.cantidadesPorRol[role] ?? 0} persona(s)',
        );
      }
    }

    print(
      'Cantidades por rol: '
      '${proyecto.cantidadesPorRol}',
    );

    print(
      'Habilidades: '
      '${proyecto.habilidades}',
    );

    print(
      'Requisitos: '
      '${proyecto.requisitos}',
    );

    print(
      'Tipo de proyecto: '
      '${proyecto.tipoProyecto ?? 'No seleccionado'}',
    );

    print('');
    print('--- FECHAS ---');

    print(
      'Fecha de inicio: '
      '${_formatearFecha(proyecto.fechaInicio)}',
    );

    print(
      'Fecha de cierre: '
      '${_formatearFecha(proyecto.fechaCierre)}',
    );

    print('');
    print('--- DOCENTE ---');

    print(
      '¿Desea docente asesor?: '
      '${proyecto.deseaDocente ? 'Sí' : 'No'}',
    );

    print('==================================================');
  }

  // ====================================================
  // PUBLICAR PROYECTO
  // ====================================================

  void _publicarProyecto(BuildContext context) {
    // ==================================================
    // CREAR EL OBJETO
    // ==================================================

    final CreatedProjectInfo nuevoProyecto =
        CreatedProjectInfo(
      // -----------------------------------------------
      // Primera pantalla
      // -----------------------------------------------

      nombreProyecto: nombreProyecto,
      descripcion: descripcion,
      liderProyecto: liderProyecto,
      categoria: categoria,

      // -----------------------------------------------
      // Segunda pantalla
      // -----------------------------------------------

      objetivo: objetivo,

      roles: List<String>.from(
        roles,
      ),

      cantidadesPorRol:
          Map<String, int>.from(
        cantidadesPorRol,
      ),

      habilidades:
          List<String>.from(
        habilidades,
      ),

      requisitos: requisitos,

      tipoProyecto: tipoProyecto,

      // -----------------------------------------------
      // Fechas
      // -----------------------------------------------

      fechaInicio: fechaInicio,
      fechaCierre: fechaCierre,

      // -----------------------------------------------
      // Docente
      // -----------------------------------------------

      deseaDocente: deseaDocente,
    );

    // ==================================================
    // GUARDAR EN LA LISTA
    // ==================================================

    createdProjects.add(
      nuevoProyecto,
    );

    // ==================================================
    // IMPRIMIR RESULTADO
    // ==================================================

    print('');
    print('');
    print('##################################################');
    print('       PROYECTO PUBLICADO CORRECTAMENTE');
    print('##################################################');

    print(
      'Cantidad total de proyectos: '
      '${createdProjects.length}',
    );

    // Imprimir todos los proyectos guardados
    for (int i = 0;
        i < createdProjects.length;
        i++) {
      _imprimirProyecto(
        createdProjects[i],
        i + 1,
      );
    }

    print('');
    print('##################################################');
    print('          FIN DE LA LISTA DE PROYECTOS');
    print('##################################################');
    print('');

    // ==================================================
    // VOLVER AL INICIO
    // ==================================================

    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  // ====================================================
  // BUILD
  // ====================================================

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color pageBackground = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5);

    final Color cardColor = isDarkMode
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFD9D9D9);

    final Color primaryTextColor =
        isDarkMode
            ? Colors.white
            : Colors.black87;

    final Color secondaryTextColor =
        isDarkMode
            ? Colors.white70
            : Colors.black87;

    final Color infoBoxColor = isDarkMode
        ? const Color(0xFF3A3A3A)
        : Colors.white;

    return Scaffold(
      backgroundColor:
          pageBackground,

      body: Column(
          children: [
            // ==========================================
            // CONTENIDO
            // ==========================================

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),

                child: Center(
                  child: Container(
                    width:
                        double.infinity,

                    constraints:
                        const BoxConstraints(
                      maxWidth: 340,
                    ),

                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      20,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          cardColor,

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(
                            0.20,
                          ),

                          blurRadius:
                              6,

                          offset:
                              const Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,

                      children: [
                        // ==================================
                        // TÍTULO
                        // ==================================

                        Text(
                          'Confirma tu información',

                          textAlign:
                              TextAlign.center,

                          style:
                              TextStyle(
                            fontSize: 17,

                            fontWeight:
                                FontWeight.bold,

                            color:
                                primaryTextColor,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Divider(
                          color:
                              isDarkMode
                                  ? Colors.white24
                                  : Colors.white,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // ==================================
                        // DESCRIPCIÓN
                        // ==================================

                        Text(
                          'Asegúrate de que toda la información esté correcta antes de publicar el proyecto',

                          textAlign:
                              TextAlign.center,

                          style:
                              TextStyle(
                            fontSize: 12,

                            color:
                                secondaryTextColor,

                            height:
                                1.35,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // ==================================
                        // INFORMACIÓN IMPORTANTE
                        // ==================================

                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets.all(
                            10,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                infoBoxColor,

                            borderRadius:
                                BorderRadius.circular(
                              8,
                            ),
                          ),

                          child:
                              Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              // --------------------------------
                              // ICONO
                              // --------------------------------

                              Container(
                                width:
                                    25,

                                height:
                                    25,

                                decoration:
                                    const BoxDecoration(
                                  color:
                                      primaryRed,

                                  shape:
                                      BoxShape.circle,
                                ),

                                child:
                                    const Center(
                                  child:
                                      Text(
                                    'i',

                                    style:
                                        TextStyle(
                                      color:
                                          Colors.white,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              // --------------------------------
                              // TEXTO
                              // --------------------------------

                              Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    Text(
                                      'Importante:',

                                      style:
                                          TextStyle(
                                        fontSize:
                                            12,

                                        fontWeight:
                                            FontWeight.bold,

                                        color:
                                            primaryTextColor,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    Text(
                                      'Tú serás el líder del proyecto.',

                                      style:
                                          TextStyle(
                                        fontSize:
                                            11,

                                        color:
                                            secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        // ==================================
                        // PREGUNTA
                        // ==================================

                        Text(
                          '¿Estás segur@ de publicar?',

                          textAlign:
                              TextAlign.center,

                          style:
                              TextStyle(
                            fontSize: 13,

                            fontWeight:
                                FontWeight.w500,

                            color:
                                primaryTextColor,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // ==================================
                        // BOTONES
                        // ==================================

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [
                            // --------------------------------
                            // EDITAR
                            // --------------------------------

                            SizedBox(
                              width:
                                  85,

                              height:
                                  40,

                              child:
                                  ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },

                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      primaryRed,

                                  foregroundColor:
                                      Colors.white,

                                  elevation:
                                      0,

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                ),

                                child:
                                    const Text(
                                  'Editar',

                                  style:
                                      TextStyle(
                                    fontSize:
                                        12,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            // --------------------------------
                            // PUBLICAR
                            // --------------------------------

                            SizedBox(
                              width:
                                  85,

                              height:
                                  40,

                              child:
                                  ElevatedButton(
                                onPressed: () {
                                  _publicarProyecto(
                                    context,
                                  );
                                },

                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      primaryRed,

                                  foregroundColor:
                                      Colors.white,

                                  elevation:
                                      0,

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                ),

                                child:
                                    const Text(
                                  'Publicar',

                                  style:
                                      TextStyle(
                                    fontSize:
                                        12,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}