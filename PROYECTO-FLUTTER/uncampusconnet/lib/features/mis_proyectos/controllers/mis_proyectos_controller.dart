import 'package:get/get.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';

class MyProjectsController extends GetxController {
  final SesionController _sesionController = Get.find<SesionController>();

  /// Indicador de carga
  final cargando = false.obs;

  /// Proyectos del usuario (desde Roble)
  final proyectos = <ProjectData>[].obs;

  /// Texto de búsqueda
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarProyectos();
  }

  //Cargar proyectos
  Future<void> cargarProyectos() async {
    cargando.value = true;

    try {
      // 1. ID del usuario
      final idUsuario = _sesionController.idUsuario;
      if (idUsuario == null) {
        proyectos.clear();
        return;
      }

      // 2. Obtener los integrantes del usuario
      final integrantes = await RobleClient.instance.read(
        'integrantes',
        filters: {'id_usuario': idUsuario},
      );

      if (integrantes.isEmpty) {
        proyectos.clear();
        return;
      }

      // 3. Construir la lista de ProjectData
      final lista = <ProjectData>[];

      for (final integrante in integrantes) {
        final idProyecto = int.tryParse(
          integrante['id_proyecto'].toString(),
        );
        final idRol = int.tryParse(
          integrante['id_rol'].toString(),
        );

        if (idProyecto == null) continue;

        final project = await _construirProjectData(
          idProyecto: idProyecto,
          idRol: idRol,
        );

        if (project != null) {
          lista.add(project);
        }
      }

      proyectos.assignAll(lista);
    } catch (e) {
      proyectos.clear();
    } finally {
      cargando.value = false;
    }
  }

  Future<ProjectData?> _construirProjectData({
    required int idProyecto,
    int? idRol,
  }) async {
    // 1. Obtener el proyecto
    final proyectosRaw = await RobleClient.instance.read(
      'proyecto',
      filters: {'id_proyecto': idProyecto},
    );

    if (proyectosRaw.isEmpty) return null;

    final proyecto = proyectosRaw.first;

    // 2. Obtener el nombre del líder (id_creador → tabla usuario)
    final idCreador = int.tryParse(
      proyecto['id_creador'].toString(),
    );
    final nombreLider = await _obtenerNombreUsuario(idCreador);

    // 3. Obtener el nombre de la categoría
    final idCategoria = int.tryParse(
      proyecto['id_categoria'].toString(),
    );
    final nombreCategoria = await _obtenerNombreCategoria(idCategoria);

    // 4. Construir ProjectData
    return ProjectData(
      idProyecto: idProyecto,
      title: proyecto['nombre']?.toString() ?? 'Sin nombre',
      leader: '@$nombreLider',
      description: proyecto['descripcion']?.toString() ?? '',
      requirements: proyecto['requisitos']?.toString() ?? '',
      category: nombreCategoria,
      membersCount: int.tryParse(
            proyecto['num_integrantes'].toString(),
          ) ??
          0,
      vacancies: 0,
      vacancyRoles: const {},
      closingDate: null,
      progress: 0.0,
    );
  }

  //Helpers
  Future<String> _obtenerNombreUsuario(int? idUsuario) async {
    if (idUsuario == null) return '';

    final usuarios = await RobleClient.instance.read(
      'usuario',
      filters: {'id_usuario': idUsuario},
    );

    if (usuarios.isEmpty) return '';

    return usuarios.first['nombre_usuario']?.toString() ?? '';
  }

  Future<String> _obtenerNombreCategoria(int? idCategoria) async {
    if (idCategoria == null) return '';

    final categorias = await RobleClient.instance.read(
      'categoria',
      filters: {'id_categoria': idCategoria},
    );

    if (categorias.isEmpty) return '';

    return categorias.first['nombre_categoria']?.toString() ?? '';
  }

  //Busqueda
  void search(String value) {
    searchText.value = value;
  }

  /// Proyectos filtrados por búsqueda
  List<ProjectData> get filteredProjects {
    final query = searchText.value.trim().toLowerCase();

    if (query.isEmpty) {
      return proyectos;
    }

    return proyectos.where((project) {
      return project.title.toLowerCase().contains(query);
    }).toList();
  }
}