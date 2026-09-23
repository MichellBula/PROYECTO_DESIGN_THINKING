import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uncampusconnet/features/buscar/data/buscar_remote_datasource.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';

class BuscarController extends GetxController {
  final searchController = TextEditingController();

  final BuscarRemoteDatasource datasource = BuscarRemoteDatasource();

  final showAvailable = true.obs;
  final filters = <String>[].obs;

  // Proyectos cargados desde Roble.
  final projects = <ProjectInfo>[].obs;

  // Estados de la consulta.
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  // ======================================================
  // CARGAR PROYECTOS DESDE ROBLE
  // ======================================================

  Future<void> loadProjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('');
      print('==================================================');
      print('[BUSCAR_CONTROLLER] CARGANDO PROYECTOS');
      print('==================================================');

      final result = await datasource.getProjects();

      projects.assignAll(result);

      print(
        '[BUSCAR_CONTROLLER] ✅ Proyectos cargados: '
        '${projects.length}',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'No fue posible cargar los proyectos.';

      debugPrint('[BUSCAR_CONTROLLER] ❌ Error cargando proyectos: $e');

      debugPrint('[BUSCAR_CONTROLLER] StackTrace:\n$stackTrace');
    } finally {
      isLoading.value = false;

      print('[BUSCAR_CONTROLLER] Consulta finalizada.');
    }
  }

  // ======================================================
  // PROYECTOS VISIBLES
  // ======================================================

  List<ProjectInfo> get visibleProjects {
    return projects.where((project) {
      final isAvailable = isProjectAvailable(project);

      if (showAvailable.value != isAvailable) {
        return false;
      }

      if (filters.isEmpty) {
        return true;
      }

      final searchableText = [
        project.name,
        project.leader,
        project.area,
        project.description,
        project.keywords,
        ...project.requirements,
        ...project.roles,
      ].join(' ').toLowerCase();

      return filters.every(searchableText.contains);
    }).toList();
  }

  // ======================================================
  // VALIDAR DISPONIBILIDAD
  // ======================================================

  bool isProjectAvailable(ProjectInfo project) {
    final parts = project.closingDate.split('/');

    if (parts.length != 3) {
      return false;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return false;
    }

    final closingDate = DateTime(year, month, day, 23, 59, 59);

    return !DateTime.now().isAfter(closingDate);
  }

  // ======================================================
  // CAMBIAR ENTRE DISPONIBLES / ANTERIORES
  // ======================================================

  void changeView(bool value) {
    showAvailable.value = value;
  }

  // ======================================================
  // FILTROS
  // ======================================================

  void addFilter() {
    final value = searchController.text.trim().toLowerCase();

    if (value.isEmpty) {
      return;
    }

    if (!filters.contains(value)) {
      filters.add(value);
    }

    searchController.clear();
  }

  void removeFilter(String filter) {
    filters.remove(filter);
  }

  void clearFilters() {
    filters.clear();
    searchController.clear();
  }

  // ======================================================
  // RECARGAR
  // ======================================================

  Future<void> refreshProjects() async {
    await loadProjects();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
