
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';

class MyProjectsController extends GetxController {
  final SesionController _sesionController = Get.find<SesionController>();

  final cargando = false.obs;
  final proyectos = <ProjectData>[].obs;
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarProyectos();
  }

  Future<void> cargarProyectos() async {
    cargando.value = true;

    try {
      final idUsuario = _sesionController.idUsuario;

      if (idUsuario == null) {
        debugPrint('[MIS_PROYECTOS] Usuario sin perfil');
        proyectos.clear();
        return;
      }

      debugPrint('[MIS_PROYECTOS] Usuario: $idUsuario');

      // Proyectos creados por el usuario.
      final proyectosCreados = await RobleClient.instance.read(
        'proyecto',
        filters: {'id_creador': idUsuario},
      );

      // Proyectos donde el usuario es integrante.
      final integrantes = await RobleClient.instance.read(
        'integrantes',
        filters: {'id_usuario': idUsuario},
      );

      debugPrint(
        '[MIS_PROYECTOS] Creados: ${proyectosCreados.length}',
      );

      debugPrint(
        '[MIS_PROYECTOS] Participaciones: ${integrantes.length}',
      );

      // Evitar proyectos duplicados.
      final idsProyectos = <int>{};

      for (final proyecto in proyectosCreados) {
        final idProyecto = int.tryParse(
          proyecto['id_proyecto'].toString(),
        );

        if (idProyecto != null) {
          idsProyectos.add(idProyecto);
        }
      }

      for (final integrante in integrantes) {
        final idProyecto = int.tryParse(
          integrante['id_proyecto'].toString(),
        );

        if (idProyecto != null) {
          idsProyectos.add(idProyecto);
        }
      }

      final lista = <ProjectData>[];

      for (final idProyecto in idsProyectos) {
        try {
          final proyecto = await _construirProjectData(
            idProyecto: idProyecto,
          );

          if (proyecto != null) {
            lista.add(proyecto);
          }
        } catch (e) {
          debugPrint(
            '[MIS_PROYECTOS] Error en proyecto $idProyecto: $e',
          );
        }
      }

      proyectos.assignAll(lista);

      debugPrint(
        '[MIS_PROYECTOS] Proyectos cargados: ${lista.length}',
      );
    } catch (e, stackTrace) {
      debugPrint('[MIS_PROYECTOS] Error al cargar: $e');
      debugPrint('$stackTrace');
      proyectos.clear();
    } finally {
      cargando.value = false;
    }
  }

  Future<ProjectData?> _construirProjectData({
    required int idProyecto,
  }) async {
    final proyectosRaw = await RobleClient.instance.read(
      'proyecto',
      filters: {'id_proyecto': idProyecto},
    );

    if (proyectosRaw.isEmpty) return null;

    final proyecto = proyectosRaw.first;

    final idCreador = int.tryParse(
      proyecto['id_creador'].toString(),
    );

    final nombreLider = await _obtenerNombreUsuario(idCreador);

    final idCategoria = int.tryParse(
      proyecto['id_categoria'].toString(),
    );

    final nombreCategoria = await _obtenerNombreCategoria(
      idCategoria,
    );

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

  void search(String value) {
    searchText.value = value;
  }

  List<ProjectData> get filteredProjects {
    final query = searchText.value.trim().toLowerCase();

    if (query.isEmpty) {
      return proyectos.toList();
    }

    return proyectos.where((project) {
      return project.title.toLowerCase().contains(query);
    }).toList();
  }
}
