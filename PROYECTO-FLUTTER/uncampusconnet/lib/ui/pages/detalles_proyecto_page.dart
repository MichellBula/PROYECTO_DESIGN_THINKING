import 'package:flutter/material.dart';


import 'package:uncampusconnet/ui/widgets/information_list.dart';
import 'package:uncampusconnet/ui/widgets/select_downdrop.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';
import 'package:uncampusconnet/ui/pages/confirmar_proyecto_page.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color.fromARGB(255, 80, 0, 0);
const Color darkRed = Color(0xFF941818);

// ======================================================
// PÁGINA DETALLES DEL PROYECTO
// ======================================================

class DetallesProyectoPage extends StatefulWidget {
  final String nombreProyecto;
  final String descripcion;
  final String liderProyecto;
  final String categoria;

  const DetallesProyectoPage({
    super.key,
    required this.nombreProyecto,
    required this.descripcion,
    required this.liderProyecto,
    required this.categoria,
  });

  @override
  State<DetallesProyectoPage> createState() =>
      _DetallesProyectoPageState();
}

class _DetallesProyectoPageState
    extends State<DetallesProyectoPage> {
  // ====================================================
  // CONTROLADORES DE TEXTO
  // ====================================================

  final TextEditingController objetivoController =
      TextEditingController();

  final TextEditingController requisitosController =
      TextEditingController();

  // ====================================================
  // OPCIONES SELECCIONADAS
  // ====================================================

  List<String> selectedRoles = [];
  List<String> selectedSkills = [];

  String? selectedProjectType;

  // ====================================================
  // CANTIDAD DE PERSONAS POR ROL
  // ====================================================

  final Map<String, int> roleQuantities = {};

  // ====================================================
  // DATOS ADICIONALES
  // ====================================================

  DateTime? fechaInicio;
  DateTime? fechaCierre;

  bool deseaDocente = false;

  // ====================================================
  // DISPOSE
  // ====================================================

  @override
  void dispose() {
    objetivoController.dispose();
    requisitosController.dispose();

    super.dispose();
  }

  // ====================================================
  // SELECCIONAR FECHA
  // ====================================================

  Future<void> seleccionarFecha(int tipoFecha) async {
    final DateTime hoy = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    DateTime primeraFecha;
    DateTime fechaInicial;

    // ==========================================
    // FECHA DE INICIO
    // ==========================================

    if (tipoFecha == 1) {
      primeraFecha = hoy;
      fechaInicial = fechaInicio ?? hoy;
    }

    // ==========================================
    // FECHA DE CIERRE
    // ==========================================

    else {
      if (fechaInicio == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Primero debes seleccionar la fecha de inicio.',
            ),
          ),
        );

        return;
      }

      // La fecha de cierre debe ser mínimo
      // 7 días después de la fecha de inicio.
      primeraFecha = fechaInicio!.add(
        const Duration(days: 7),
      );

      fechaInicial = fechaCierre ?? primeraFecha;
    }

    // Evitar que initialDate sea menor que firstDate.
    if (fechaInicial.isBefore(primeraFecha)) {
      fechaInicial = primeraFecha;
    }

    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: primeraFecha,
      lastDate: DateTime(2035),
    );

    if (fecha == null) {
      return;
    }

    setState(() {
      // ========================================
      // FECHA DE INICIO
      // ========================================

      if (tipoFecha == 1) {
        fechaInicio = fecha;

        // Si la fecha de cierre seleccionada
        // ya no cumple los 7 días mínimos,
        // se elimina para volver a seleccionarla.
        final DateTime fechaMinimaCierre =
            fechaInicio!.add(
          const Duration(days: 7),
        );

        if (fechaCierre != null &&
            fechaCierre!.isBefore(fechaMinimaCierre)) {
          fechaCierre = null;
        }
      }

      // ========================================
      // FECHA DE CIERRE
      // ========================================

      else {
        fechaCierre = fecha;
      }
    });
  }

  // ====================================================
  // MOSTRAR FECHA
  // ====================================================

  String mostrarFecha(DateTime? fecha) {
    if (fecha == null) {
      return 'dd / mm / yyyy';
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
  // ACTUALIZAR ROLES
  // ====================================================

  void actualizarRoles(List<String> values) {
    setState(() {
      selectedRoles = values;

      for (final String role in values) {
        roleQuantities.putIfAbsent(
          role,
          () => 0,
        );
      }

      roleQuantities.removeWhere(
        (role, quantity) => !values.contains(role),
      );
    });
  }

  // ====================================================
  // CAMBIAR CANTIDAD DE UN ROL
  // ====================================================

  void cambiarCantidadRol(
    String role,
    int cambio,
  ) {
    setState(() {
      final int cantidadActual =
          roleQuantities[role] ?? 0;

      final int nuevaCantidad =
          cantidadActual + cambio;

      if (nuevaCantidad >= 0) {
        roleQuantities[role] =
            nuevaCantidad;
      }
    });
  }

  // ====================================================
  // VALIDAR FORMULARIO
  // ====================================================

  bool validarFormulario() {
    // ==========================================
    // OBJETIVO
    // ==========================================

    if (objetivoController.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes completar el objetivo general.',
          ),
        ),
      );

      return false;
    }

    // ==========================================
    // ROLES
    // ==========================================

    if (selectedRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes seleccionar al menos un rol.',
          ),
        ),
      );

      return false;
    }

    // ==========================================
    // CANTIDAD DE CADA ROL
    // ==========================================

    for (final String role in selectedRoles) {
      final int cantidad =
          roleQuantities[role] ?? 0;

      if (cantidad <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Debes indicar al menos 1 integrante para "$role".',
            ),
          ),
        );

        return false;
      }
    }

    // ==========================================
    // HABILIDADES
    // ==========================================

    if (selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes seleccionar al menos una habilidad.',
          ),
        ),
      );

      return false;
    }

    // ==========================================
    // REQUISITOS
    // ==========================================

    if (requisitosController.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes completar los requisitos.',
          ),
        ),
      );

      return false;
    }

    // ==========================================
    // TIPO DE PROYECTO
    // ==========================================

    if (selectedProjectType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes seleccionar el tipo de proyecto.',
          ),
        ),
      );

      return false;
    }

    // ==========================================
    // FECHA DE INICIO
    // ==========================================

    if (fechaInicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes seleccionar la fecha de inicio.',
          ),
        ),
      );

      return false;
    }

    // ==========================================
    // FECHA DE CIERRE
    // ==========================================

    if (fechaCierre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes seleccionar la fecha de cierre.',
          ),
        ),
      );

      return false;
    }

    // ==========================================
    // FECHA DE HOY
    // ==========================================

    final DateTime hoy = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // ==========================================
    // INICIO NO PUEDE SER ANTERIOR A HOY
    // ==========================================

    if (fechaInicio!.isBefore(hoy)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La fecha de inicio no puede ser anterior a hoy.',
          ),
        ),
      );

      return false;
    }

    // ==========================================
    // CIERRE MÍNIMO 7 DÍAS DESPUÉS
    // ==========================================

    final DateTime fechaMinimaCierre =
        fechaInicio!.add(
      const Duration(days: 7),
    );

    if (fechaCierre!.isBefore(fechaMinimaCierre)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La fecha de cierre debe ser mínimo 7 días después de la fecha de inicio.',
          ),
        ),
      );

      return false;
    }

    return true;
  }

  // ====================================================
  // IR A CONFIRMAR PROYECTO
  // ====================================================

  void continuarAConfirmacion() {
    if (!validarFormulario()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConfirmarProyectoPage(
          // ==========================================
          // DATOS DE LA PRIMERA PANTALLA
          // ==========================================

          nombreProyecto:
              widget.nombreProyecto,

          descripcion:
              widget.descripcion,

          liderProyecto:
              widget.liderProyecto,

          categoria:
              widget.categoria,

          // ==========================================
          // DATOS DE ESTA PANTALLA
          // ==========================================

          objetivo:
              objetivoController.text.trim(),

          roles:
              List<String>.from(
            selectedRoles,
          ),

          cantidadesPorRol:
              Map<String, int>.from(
            roleQuantities,
          ),

          habilidades:
              List<String>.from(
            selectedSkills,
          ),

          requisitos:
              requisitosController.text.trim(),

          tipoProyecto:
              selectedProjectType,

          // ==========================================
          // FECHAS
          // ==========================================

          fechaInicio:
              fechaInicio,

          fechaCierre:
              fechaCierre,

          // ==========================================
          // DOCENTE
          // ==========================================

          deseaDocente:
              deseaDocente,
        ),
      ),
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

    final Color primaryTextColor = isDarkMode
        ? Colors.white
        : Colors.black87;

    final Color hintColor = isDarkMode
        ? Colors.white60
        : Colors.grey;

    final Color fieldBackground = isDarkMode
        ? const Color(0xFF2A2A2A)
        : Colors.white;

    final Color dividerColor = isDarkMode
        ? const Color(0xFF333333)
        : const Color(0xFFD9D9D9);

    final Color secondaryTextColor =
        isDarkMode
            ? Colors.white70
            : Colors.black87;

    return Scaffold(
      backgroundColor: pageBackground,

      body: Column(
          children: [

            // ==========================================
            // CONTENIDO SCROLLEABLE
            // ==========================================

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 34,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ======================================
                    // TÍTULO
                    // ======================================

                    SizedBox(
                      height: 52,

                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },

                            child: Icon(
                              Icons.chevron_left,
                              size: 28,
                              color:
                                  primaryTextColor,
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                'Nuevo proyecto',

                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      primaryTextColor,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 28,
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      color:
                          dividerColor,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // ======================================
                    // SUBTÍTULO
                    // ======================================

                    Center(
                      child: Text(
                        'Información general:',
                        style: TextStyle(
                          fontSize: 16,
                          color: hintColor,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // ======================================
                    // OBJETIVO GENERAL
                    // ======================================

                    Text(
                      'Objetivo general:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    _buildTextField(
                      controller:
                          objetivoController,
                      hintText:
                          'El objetivo de mi proyecto es...',
                      backgroundColor:
                          fieldBackground,
                      hintColor:
                          hintColor,
                      textColor:
                          primaryTextColor,
                      maxLines: 3,
                      maxLength: 300,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // ======================================
                    // ROLES
                    // ======================================

                    Text(
                      '¿Qué roles necesitas?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    MultiSelectDropdown(
                      hintText:
                          'Puedes escoger más de un rol',
                      options:
                          roles,
                      selectedItems:
                          selectedRoles,
                      onChanged:
                          actualizarRoles,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // ======================================
                    // HABILIDADES
                    // ======================================

                    Text(
                      'Habilidades necesarias:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    MultiSelectDropdown(
                      hintText:
                          'Puedes escoger más de una habilidad',
                      options:
                          skills,
                      selectedItems:
                          selectedSkills,
                      onChanged: (values) {
                        setState(() {
                          selectedSkills =
                              values;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // ======================================
                    // REQUISITOS
                    // ======================================

                    Text(
                      'Requisitos:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    _buildTextField(
                      controller:
                          requisitosController,
                      hintText:
                          'Los requisitos son...',
                      backgroundColor:
                          fieldBackground,
                      hintColor:
                          hintColor,
                      textColor:
                          primaryTextColor,
                      maxLines: 3,
                      maxLength: 300,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // ======================================
                    // TIPO DE PROYECTO
                    // ======================================

                    Text(
                      'Tipo de proyecto:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    _buildProjectTypeDropdown(
                      backgroundColor:
                          fieldBackground,
                      textColor:
                          primaryTextColor,
                      hintColor:
                          hintColor,
                    ),

                    // =================================================
                    // NÚMERO DE INTEGRANTES
                    // =================================================

                    const SizedBox(
                      height: 25,
                    ),

                    Text(
                      'Número de integrantes:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    if (selectedRoles.isEmpty)
                      Text(
                        'Selecciona primero los roles que necesitas.',
                        style: TextStyle(
                          fontSize: 11,
                          color: hintColor,
                        ),
                      )
                    else
                      Column(
                        children:
                            selectedRoles
                                .map(
                          (
                            String role,
                          ) {
                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 10,
                              ),
                              child:
                                  _buildRoleQuantityRow(
                                role:
                                    role,
                                backgroundColor:
                                    fieldBackground,
                                textColor:
                                    primaryTextColor,
                              ),
                            );
                          },
                        ).toList(),
                      ),

                    const SizedBox(
                      height: 10,
                    ),

                    // ======================================
                    // FECHA DE INICIO
                    // ======================================

                    Text(
                      'Fecha de inicio:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    _buildDateButton(
                      fecha:
                          fechaInicio,
                      onTap: () {
                        seleccionarFecha(1);
                      },
                      backgroundColor:
                          fieldBackground,
                      textColor:
                          primaryTextColor,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // ======================================
                    // FECHA DE CIERRE
                    // ======================================

                    Text(
                      'Fecha de cierre:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    _buildDateButton(
                      fecha:
                          fechaCierre,
                      onTap: () {
                        seleccionarFecha(2);
                      },
                      backgroundColor:
                          fieldBackground,
                      textColor:
                          primaryTextColor,
                    ),

                    // ======================================
                    // DOCENTE ASESOR
                    // ======================================

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '¿Desea docente asesor?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  primaryTextColor,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        _buildAdvisorButton(
                          text:
                              'Sí',
                          selected:
                              deseaDocente,
                          onTap: () {
                            setState(() {
                              deseaDocente =
                                  true;
                            });
                          },
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        _buildAdvisorButton(
                          text:
                              'No',
                          selected:
                              !deseaDocente,
                          onTap: () {
                            setState(() {
                              deseaDocente =
                                  false;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    // ======================================
                    // BOTONES
                    // ======================================

                    Row(
                      children: [
                        // ----------------------------------
                        // ATRÁS
                        // ----------------------------------

                        Expanded(
                          child: SizedBox(
                            height: 42,
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
                                      BorderRadius
                                          .circular(
                                    8,
                                  ),
                                ),
                              ),
                              child:
                                  const Text(
                                'Atrás',
                                style:
                                    TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        // ----------------------------------
                        // CREAR PROYECTO
                        // ----------------------------------

                        Expanded(
                          child: SizedBox(
                            height: 42,
                            child:
                                ElevatedButton(
                              onPressed:
                                  continuarAConfirmacion,
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
                                      BorderRadius
                                          .circular(
                                    8,
                                  ),
                                ),
                              ),
                              child:
                                  const Text(
                                'Crear proyecto',
                                style:
                                    TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // BARRA INFERIOR
            // ==========================================

          
          ],
      ),
    );
  }

  // ======================================================
  // CAMPO DE TEXTO
  // ======================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Color backgroundColor,
    required Color hintColor,
    required Color textColor,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      width: double.infinity,
      decoration:
          BoxDecoration(
        color:
            backgroundColor,
        borderRadius:
            BorderRadius.circular(
          8,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.18,
            ),
            blurRadius:
                4,
            offset:
                const Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      child:
          TextField(
        controller:
            controller,
        maxLines:
            maxLines,
        maxLength:
            maxLength,
        style:
            TextStyle(
          fontSize:
              12,
          color:
              textColor,
        ),
        decoration:
            InputDecoration(
          hintText:
              hintText,
          hintStyle:
              TextStyle(
            fontSize:
                12,
            color:
                hintColor,
          ),
          border:
              InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal:
                12,
            vertical:
                10,
          ),
        ),
      ),
    );
  }

  // ======================================================
  // TIPO DE PROYECTO
  // ======================================================

  Widget _buildProjectTypeDropdown({
    required Color backgroundColor,
    required Color textColor,
    required Color hintColor,
  }) {
    return Container(
      height: 38,
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration:
          BoxDecoration(
        color:
            backgroundColor,
        borderRadius:
            BorderRadius.circular(
          8,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.15,
            ),
            blurRadius:
                4,
            offset:
                const Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      child:
          DropdownButtonHideUnderline(
        child:
            DropdownButton<String>(
          value:
              selectedProjectType,
          hint:
              Text(
            'Selecciona el tipo de proyecto',
            style:
                TextStyle(
              fontSize:
                  12,
              color:
                  hintColor,
            ),
          ),
          isExpanded:
              true,
          icon:
              Icon(
            Icons
                .keyboard_arrow_down,
            size:
                22,
            color:
                textColor,
          ),
          items:
              projectTypes.map(
            (
              type,
            ) {
              return DropdownMenuItem<
                  String>(
                value:
                    type,
                child:
                    Text(
                  type,
                  style:
                      TextStyle(
                    fontSize:
                        12,
                    color:
                        textColor,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged:
              (value) {
            setState(() {
              selectedProjectType =
                  value;
            });
          },
        ),
      ),
    );
  }

  // ======================================================
  // ROL + CANTIDAD
  // ======================================================

  Widget _buildRoleQuantityRow({
    required String role,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final int quantity =
        roleQuantities[role] ?? 0;

    return Row(
      children: [
        // ================================================
        // NOMBRE DEL ROL
        // ================================================

        Expanded(
          child: Container(
            height: 38,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration:
                BoxDecoration(
              color:
                  backgroundColor,
              borderRadius:
                  BorderRadius.circular(
                8,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(
                    0.18,
                  ),
                  blurRadius:
                      4,
                  offset:
                      const Offset(
                    0,
                    2,
                  ),
                ),
              ],
            ),
            child:
                Align(
              alignment:
                  Alignment.centerLeft,
              child:
                  Text(
                role,
                style:
                    TextStyle(
                  fontSize:
                      12,
                  color:
                      textColor,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        // ================================================
        // CONTADOR
        // ================================================

        Container(
          height: 38,
          width: 88,
          decoration:
              BoxDecoration(
            color:
                backgroundColor,
            borderRadius:
                BorderRadius.circular(
              8,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(
                  0.18,
                ),
                blurRadius:
                    4,
                offset:
                    const Offset(
                  0,
                  2,
                ),
              ),
            ],
          ),
          child:
              Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              // MENOS

              GestureDetector(
                onTap: () {
                  cambiarCantidadRol(
                    role,
                    -1,
                  );
                },
                child:
                    Text(
                  '−',
                  style:
                      TextStyle(
                    fontSize:
                        18,
                    color:
                        textColor,
                  ),
                ),
              ),

              // CANTIDAD

              Text(
                quantity
                    .toString()
                    .padLeft(
                  2,
                  '0',
                ),
                style:
                    TextStyle(
                  fontSize:
                      13,
                  color:
                      textColor,
                ),
              ),

              // MÁS

              GestureDetector(
                onTap: () {
                  cambiarCantidadRol(
                    role,
                    1,
                  );
                },
                child:
                    Text(
                  '+',
                  style:
                      TextStyle(
                    fontSize:
                        18,
                    color:
                        textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ======================================================
  // BOTÓN FECHA
  // ======================================================

  Widget _buildDateButton({
    required DateTime? fecha,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap:
          onTap,
      child:
          Container(
        width:
            double.infinity,
        height:
            38,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration:
            BoxDecoration(
          color:
              backgroundColor,
          borderRadius:
              BorderRadius.circular(
            8,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(
                0.18,
              ),
              blurRadius:
                  4,
              offset:
                  const Offset(
                0,
                2,
              ),
            ),
          ],
        ),
        child:
            Row(
          children: [
            Expanded(
              child:
                  Text(
                mostrarFecha(
                  fecha,
                ),
                style:
                    TextStyle(
                  fontSize:
                      12,
                  color:
                      fecha == null
                          ? Colors.grey
                          : textColor,
                ),
              ),
            ),
            Icon(
              Icons
                  .calendar_today_outlined,
              size:
                  18,
              color:
                  primaryRed,
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // BOTÓN SÍ / NO
  // ======================================================

  Widget _buildAdvisorButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap,
      child:
          Container(
        width:
            45,
        height:
            34,
        decoration:
            BoxDecoration(
          color: selected
              ? const Color(
                  0xFF999999,
                )
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
            8,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(
                0.12,
              ),
              blurRadius:
                  4,
              offset:
                  const Offset(
                0,
                2,
              ),
            ),
          ],
        ),
        child:
            Center(
          child:
              Text(
            text,
            style:
                TextStyle(
              fontSize:
                  11,
              fontWeight:
                  FontWeight.bold,
              color: selected
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}