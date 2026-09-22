import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller encargado de gestionar el estado y la lógica
/// de la pantalla de detalles del proyecto.
///
/// Utiliza GetX para mantener las variables reactivas y
/// evitar utilizar `setState()` directamente en la pantalla.
class ProjectDetailsController extends GetxController {
  // ======================================================
  // CONTROLADORES DE TEXTO
  // ======================================================

  /// Controla el objetivo general del proyecto.
  final objetivoController = TextEditingController();

  /// Controla los requisitos del proyecto.
  final requisitosController = TextEditingController();

  // ======================================================
  // ROLES Y CANTIDADES
  // ======================================================

  /// Guarda la cantidad de personas requerida para cada rol.
  ///
  /// Ejemplo:
  /// {
  ///   'Programador': 2,
  ///   'Diseñador': 1,
  /// }
  final RxMap<String, int> roleQuantities = <String, int>{}.obs;

  // ======================================================
  // HABILIDADES
  // ======================================================

  /// Habilidades seleccionadas por el usuario.
  final RxList<String> selectedSkills = <String>[].obs;

  // ======================================================
  // TIPO DE PROYECTO
  // ======================================================

  /// Tipo de proyecto seleccionado.
  final Rxn<String> selectedProjectType = Rxn<String>();

  // ======================================================
  // FECHAS
  // ======================================================

  /// Fecha de inicio del proyecto.
  final Rxn<DateTime> fechaInicio = Rxn<DateTime>();

  /// Fecha de cierre del proyecto.
  final Rxn<DateTime> fechaCierre = Rxn<DateTime>();

  // ======================================================
  // DOCENTE
  // ======================================================

  /// Indica si el usuario desea un docente asesor.
  final RxBool deseaDocente = false.obs;

  // ======================================================
  // ROLES SELECCIONADOS
  // ======================================================

  /// Obtiene los roles cuya cantidad es mayor que cero.
  List<String> get selectedRoles {
    return roleQuantities.entries
        .where((entry) => entry.value > 0)
        .map((entry) => entry.key)
        .toList();
  }

  // ======================================================
  // ROLES
  // ======================================================

  /// Actualiza las cantidades de los roles seleccionados.
  void actualizarRoles(Map<String, int> values) {
    roleQuantities.assignAll(values);
  }

  // ======================================================
  // HABILIDADES
  // ======================================================

  /// Actualiza las habilidades seleccionadas.
  void actualizarHabilidades(List<String> values) {
    selectedSkills.assignAll(values);
  }

  // ======================================================
  // TIPO DE PROYECTO
  // ======================================================

  /// Cambia el tipo de proyecto.
  void cambiarTipoProyecto(String? value) {
    selectedProjectType.value = value;
  }

  // ======================================================
  // DOCENTE
  // ======================================================

  /// Actualiza la decisión sobre docente asesor.
  void cambiarDocente(bool value) {
    deseaDocente.value = value;
  }

  // ======================================================
  // FECHAS
  // ======================================================

  /// Devuelve la fecha actual sin hora.
  DateTime get today {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  /// Devuelve la fecha mínima permitida para el cierre.
  ///
  /// El cierre debe ser como mínimo 7 días después
  /// de la fecha de inicio.
  DateTime get minimumClosingDate {
    return fechaInicio.value!.add(const Duration(days: 7));
  }

  /// Establece la fecha de inicio.
  void setFechaInicio(DateTime value) {
    fechaInicio.value = value;

    // Si la fecha de cierre ya no es válida,
    // se elimina para que pueda seleccionarse nuevamente.
    if (fechaCierre.value != null &&
        fechaCierre.value!.isBefore(minimumClosingDate)) {
      fechaCierre.value = null;
    }
  }

  /// Establece la fecha de cierre.
  void setFechaCierre(DateTime value) {
    fechaCierre.value = value;
  }

  /// Limpia todos los datos de una creación anterior.
  ///
  /// Se utiliza cuando el usuario va a comenzar
  /// un proyecto completamente nuevo.
  void limpiarFormulario() {
    // Limpia los campos de texto.
    objetivoController.clear();
    requisitosController.clear();

    // Limpia los roles y sus cantidades.
    roleQuantities.clear();

    // Limpia las habilidades seleccionadas.
    selectedSkills.clear();

    // Reinicia el tipo de proyecto.
    selectedProjectType.value = null;

    // Reinicia las fechas.
    fechaInicio.value = null;
    fechaCierre.value = null;

    // Reinicia la opción de docente asesor.
    deseaDocente.value = false;
  }
  // ======================================================
  // VALIDACIÓN
  // ======================================================

  /// Valida todos los campos obligatorios del formulario.
  ///
  /// Devuelve `null` cuando todo es correcto.
  /// Si existe un error, devuelve el mensaje correspondiente.
  String? validate() {
    if (objetivoController.text.trim().isEmpty) {
      return 'Debes completar el objetivo general.';
    }

    if (roleQuantities.isEmpty) {
      return 'Debes seleccionar al menos un rol.';
    }

    for (final entry in roleQuantities.entries) {
      if (entry.value <= 0) {
        return 'Debes indicar al menos 1 integrante para "${entry.key}".';
      }
    }

    if (selectedSkills.isEmpty) {
      return 'Debes seleccionar al menos una habilidad.';
    }

    if (requisitosController.text.trim().isEmpty) {
      return 'Debes completar los requisitos.';
    }

    if (selectedProjectType.value == null) {
      return 'Debes seleccionar el tipo de proyecto.';
    }

    if (fechaInicio.value == null) {
      return 'Debes seleccionar la fecha de inicio.';
    }

    if (fechaCierre.value == null) {
      return 'Debes seleccionar la fecha de cierre.';
    }

    if (fechaInicio.value!.isBefore(today)) {
      return 'La fecha de inicio no puede ser anterior a hoy.';
    }

    if (fechaCierre.value!.isBefore(minimumClosingDate)) {
      return 'La fecha de cierre debe ser mínimo 7 días después de la fecha de inicio.';
    }

    return null;
  }

  @override
  void onClose() {
    objetivoController.dispose();
    requisitosController.dispose();

    super.onClose();
  }
}
