import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';
import 'package:uncampusconnet/features/create_proyect/pages/detalles_proyecto_page.dart';

const Color primaryRed = Color(0xFF931212);
const Color darkRed = Color(0xFF941818);

class NuevoProyectoPage extends StatefulWidget {
  const NuevoProyectoPage({super.key});

  @override
  State<NuevoProyectoPage> createState() => _NuevoProyectoPageState();
}

class _NuevoProyectoPageState extends State<NuevoProyectoPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController liderController = TextEditingController();

  String? selectedCategory;

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    liderController.dispose();
    super.dispose();
  }

  // Regresar a Inicio dentro del MainScaffold
  void volverAlInicio() {
    Get.find<MainController>().currentIndex.value = 0;
  }

  void continuar() {
    if (nombreController.text.trim().isEmpty ||
        descripcionController.text.trim().isEmpty ||
        liderController.text.trim().isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa todos los campos antes de continuar.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesProyectoPage(
          nombreProyecto: nombreController.text.trim(),
          descripcion: descripcionController.text.trim(),
          liderProyecto: liderController.text.trim(),
          categoria: selectedCategory!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color pageBackground = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5);

    final Color primaryTextColor =
        isDarkMode ? Colors.white : Colors.black87;

    final Color fieldBackground =
        isDarkMode ? const Color(0xFF2A2A2A) : Colors.white;

    final Color hintColor =
        isDarkMode ? Colors.white60 : Colors.grey;

    final Color dividerColor = isDarkMode
        ? const Color(0xFF333333)
        : const Color(0xFFD9D9D9);

    return Scaffold(
      backgroundColor: pageBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  // TÍTULO
                  SizedBox(
                    height: 52,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: volverAlInicio,
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
                    height: 1,
                    color: dividerColor,
                  ),

                  const SizedBox(height: 28),

                  // TEXTO INTRODUCTORIO
                  Text(
                    'Crea tu nuevo proyecto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),

                  Text(
                    'compartiendo tus ideas y encuentra',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),

                  Text(
                    'compañeros para ejecutarlas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // NOMBRE
                  _buildLabel(
                    'Nombre del proyecto:',
                    primaryTextColor,
                  ),

                  const SizedBox(height: 6),

                  _buildTextField(
                    controller: nombreController,
                    hintText: 'Tu proyecto',
                    backgroundColor: fieldBackground,
                    hintColor: hintColor,
                    textColor: primaryTextColor,
                    maxLength: 50,
                  ),

                  const SizedBox(height: 18),

                  // DESCRIPCIÓN
                  _buildLabel(
                    'Descripción:',
                    primaryTextColor,
                  ),

                  const SizedBox(height: 6),

                  _buildTextField(
                    controller: descripcionController,
                    hintText: 'Mi proyecto se basa en ...',
                    backgroundColor: fieldBackground,
                    hintColor: hintColor,
                    textColor: primaryTextColor,
                    maxLines: 4,
                    maxLength: 400,
                  ),

                  const SizedBox(height: 18),

                  // LÍDER
                  _buildLabel(
                    'Líder del proyecto:',
                    primaryTextColor,
                  ),

                  const SizedBox(height: 6),

                  _buildTextField(
                    controller: liderController,
                    hintText: 'Tu nombre',
                    backgroundColor: fieldBackground,
                    hintColor: hintColor,
                    textColor: primaryTextColor,
                    maxLength: 40,
                  ),

                  const SizedBox(height: 18),

                  // CATEGORÍA
                  _buildLabel(
                    'Categoría:',
                    primaryTextColor,
                  ),

                  const SizedBox(height: 6),

                  _buildCategoryDropdown(
                    backgroundColor: fieldBackground,
                    textColor: primaryTextColor,
                    hintColor: hintColor,
                  ),

                  const SizedBox(height: 32),

                  // BOTONES
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: volverAlInicio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(
                                255,
                                80,
                                0,
                                0,
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: continuar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(
                                255,
                                80,
                                0,
                                0,
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Continuar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

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
        style: TextStyle(
          fontSize: 12,
          color: textColor,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            color: hintColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown({
    required Color backgroundColor,
    required Color textColor,
    required Color hintColor,
  }) {
    return Container(
      height: 38,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          hint: Text(
            'Tecnología',
            style: TextStyle(
              fontSize: 12,
              color: hintColor,
            ),
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: textColor,
          ),
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
          },
        ),
      ),
    );
  }
}