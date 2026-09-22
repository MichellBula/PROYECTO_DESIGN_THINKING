import 'package:get/get.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';

/// Controlador encargado del estado de la pantalla
/// "Mis proyectos".
///
/// Gestiona:
/// - Pestaña seleccionada.
/// - Texto de búsqueda.
/// - Filtrado de proyectos.
///
/// No contiene código visual.
class MyProjectsController extends GetxController {
  // ======================================================
  // PESTAÑAS
  // ======================================================

  /// `true` = Mis proyectos.
  /// `false` = Proyectos en los que participo.
  final RxBool isMyProjectsSelected = true.obs;

  // ======================================================
  // BÚSQUEDA
  // ======================================================

  /// Texto escrito en el buscador.
  final RxString searchText = ''.obs;

  // ======================================================
  // DATOS
  // ======================================================

  /// Lista base de proyectos.
  final List<ProjectData> allProjects = projects;

  // ======================================================
  // CAMBIAR PESTAÑA
  // ======================================================

  /// Cambia entre las dos pestañas.
  void changeTab(bool isMyProjects) {
    isMyProjectsSelected.value = isMyProjects;
  }

  // ======================================================
  // BÚSQUEDA
  // ======================================================

  /// Actualiza el texto de búsqueda.
  void search(String value) {
    searchText.value = value;
  }

  // ======================================================
  // PROYECTOS FILTRADOS
  // ======================================================

  /// Devuelve los proyectos que coinciden con la búsqueda.
  ///
  /// Por ahora filtra por categoría.
  /// Más adelante podemos ampliar la búsqueda a:
  /// nombre, rol, integrantes, etc.
  /// Devuelve los proyectos que coinciden con el nombre
  /// escrito en el buscador.
  List<ProjectData> get filteredProjects {
    final query = searchText.value.trim().toLowerCase();

    // Si no hay texto, mostramos todos los proyectos.
    if (query.isEmpty) {
      return allProjects;
    }

    // La búsqueda se realiza por nombre.
    return allProjects.where((project) {
      return project.title.toLowerCase().contains(query);
    }).toList();
  }
}
