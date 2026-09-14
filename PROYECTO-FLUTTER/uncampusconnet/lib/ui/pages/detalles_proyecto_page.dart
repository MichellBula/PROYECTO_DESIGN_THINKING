import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/header_banner.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';
import 'package:uncampusconnet/ui/widgets/quick_access_buttons.dart';
import 'package:uncampusconnet/ui/widgets/select_downdrop.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);
const Color darkRed = Color(0xFF941818);

// ======================================================
// PÁGINA NUEVO PROYECTO
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
  State<DetallesProyectoPage> createState() => _DetallesProyectoPageState();
}

class _DetallesProyectoPageState extends State<DetallesProyectoPage> {
  // ======================================================
  // CONTROLADORES DE TEXTO
  // ======================================================

  final TextEditingController objetivoController = TextEditingController();

  final TextEditingController requisitosController = TextEditingController();

  // ======================================================
  // OPCIONES SELECCIONADAS
  // ======================================================

  List<String> selectedRoles = [];
  List<String> selectedSkills = [];

  String? selectedProjectType;

  // ======================================================
  // OPCIONES DISPONIBLES
  // ======================================================

  @override
  void dispose() {
    objetivoController.dispose();
    requisitosController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color pageBackground = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5);

    final Color primaryTextColor = isDarkMode ? Colors.white : Colors.black87;

    final Color hintColor = isDarkMode ? Colors.white60 : Colors.grey;

    final Color fieldBackground = isDarkMode
        ? const Color(0xFF2A2A2A)
        : Colors.white;

    return Scaffold(
      backgroundColor: pageBackground,

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // HEADER
            // ==========================================

            const HeaderBanner(),

            // ==========================================
            // CONTENIDO
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ====================================
                    // TÍTULO
                    // ====================================

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
                              color: primaryTextColor,
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                'Nuevo proyecto',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 28),
                        ],
                      ),
                    ),

                    Divider(
                      color: isDarkMode
                          ? const Color(0xFF333333)
                          : const Color(0xFFD9D9D9),
                    ),

                    const SizedBox(height: 16),

                    // ====================================
                    // SUBTÍTULO
                    // ====================================
                    Center(
                      child: Text(
                        'Información general:',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ====================================
                    // OBJETIVO GENERAL
                    // ====================================
                    Text(
                      'Objetivo general:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    _buildTextField(
                      controller: objetivoController,
                      hintText: 'El objetivo de mi proyecto es...',
                      backgroundColor: fieldBackground,
                      hintColor: hintColor,
                      textColor: primaryTextColor,
                      maxLines: 3,
                      maxLength: 300,
                    ),

                    const SizedBox(height: 20),

                    // ====================================
                    // ROLES
                    // ====================================
                    Text(
                      '¿Qué roles necesitas?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    MultiSelectDropdown(
                      hintText: 'Puedes escoger más de un rol',
                      options: roles,
                      selectedItems: selectedRoles,
                      onChanged: (values) {
                        setState(() {
                          selectedRoles = values;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // ====================================
                    // HABILIDADES
                    // ====================================
                    Text(
                      'Habilidades necesarias:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    MultiSelectDropdown(
                      hintText: 'Puedes escoger más de una habilidad',
                      options: skills,
                      selectedItems: selectedSkills,
                      onChanged: (values) {
                        setState(() {
                          selectedSkills = values;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // ====================================
                    // REQUISITOS
                    // ====================================
                    Text(
                      'Requisitos:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    _buildTextField(
                      controller: requisitosController,
                      hintText: 'Los requisitos son...',
                      backgroundColor: fieldBackground,
                      hintColor: hintColor,
                      textColor: primaryTextColor,
                      maxLines: 3,
                      maxLength: 300,
                    ),

                    const SizedBox(height: 20),

                    // ====================================
                    // TIPO DE PROYECTO
                    // ====================================
                    Text(
                      'Tipo de proyecto:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    _buildProjectTypeDropdown(
                      backgroundColor: fieldBackground,
                      textColor: primaryTextColor,
                      hintColor: hintColor,
                    ),

                    const SizedBox(height: 30),

                    // ====================================
                    // BOTÓN CREAR
                    // ====================================
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Objetivo:');
                          print(objetivoController.text);

                          print('Roles:');
                          print(selectedRoles);

                          print('Habilidades:');
                          print(selectedSkills);

                          print('Requisitos:');
                          print(requisitosController.text);

                          print('Tipo:');
                          print(selectedProjectType);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Crear proyecto',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ==========================================
            // BARRA INFERIOR
            // ==========================================
            QuickAccessButtons(
              selectedItem: QuickAccessItem.crear,

              onInicioTap: () {
                Navigator.pop(context);
              },

              onBuscarTap: () {
                Navigator.pop(context);
              },

              onCrearTap: () {},

              onMisProyectosTap: () {
                Navigator.pop(context);
              },

              onSolicitudesTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // CAMPO DE TEXTO MULTILÍNEA
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
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(fontSize: 12, color: textColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 12, color: hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedProjectType,
          hint: Text(
            'Selecciona el tipo de proyecto',
            style: TextStyle(fontSize: 12, color: hintColor),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 22),
          items: projectTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: TextStyle(fontSize: 12, color: textColor),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedProjectType = value;
            });
          },
        ),
      ),
    );
  }
}
