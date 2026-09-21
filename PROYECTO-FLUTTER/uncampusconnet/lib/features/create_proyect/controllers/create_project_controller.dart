import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProjectController extends GetxController {
  // Campos de texto de la primera pantalla.
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final liderController = TextEditingController();

  // Categoría seleccionada.
  final Rxn<String> categoriaSeleccionada = Rxn<String>();

  /// Limpia todos los datos de una creación anterior.
  void limpiarFormulario() {
    nombreController.clear();
    descripcionController.clear();
    liderController.clear();
    categoriaSeleccionada.value = null;
  }

  @override
  void onClose() {
    nombreController.dispose();
    descripcionController.dispose();
    liderController.dispose();
    super.onClose();
  }
}
