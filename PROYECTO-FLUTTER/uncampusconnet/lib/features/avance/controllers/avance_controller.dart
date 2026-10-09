import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/datasources/avance_remote_datasource.dart';
import '../data/repositories/avance_repository_impl.dart';
import '../domain/entities/avance.dart';
import '../domain/usecases/create_avance.dart';
import '../domain/usecases/get_avance_by_id.dart';
import '../domain/usecases/get_avances_by_etapa.dart';
import '../domain/usecases/get_avances_by_project.dart';

class AvanceController extends GetxController {
  AvanceController({
    AvanceRepositoryImpl? repository,
  }) : repository = repository ??
            AvanceRepositoryImpl(
              datasource: AvanceRemoteDatasource(),
            );

  final AvanceRepositoryImpl repository;

  late final CreateAvance _createAvance;
  late final GetAvanceById _getAvanceById;
  late final GetAvancesByEtapa _getAvancesByEtapa;
  late final GetAvancesByProject _getAvancesByProject;

  final cargando = false.obs;
  final creando = false.obs;

  final avances = <Map<String, dynamic>>[].obs;
  final porcentajeEtapa = 0.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();

    _createAvance = CreateAvance(
      repository: repository,
    );

    _getAvanceById = GetAvanceById(
      repository: repository,
    );

    _getAvancesByEtapa = GetAvancesByEtapa(
      repository: repository,
    );

    _getAvancesByProject = GetAvancesByProject(
      repository: repository,
    );
  }

  // ==========================================================
  // CARGAR AVANCES DE ETAPA
  // ==========================================================

  Future<void> cargarAvancesPorEtapa(
    int idEtapa,
  ) async {
    cargando.value = true;
    error.value = null;

    try {
      final resultado = await _getAvancesByEtapa(
        idEtapa,
      );

      final porcentaje =
          await repository.getPorcentajeByEtapa(
        idEtapa,
      );

      avances.assignAll(
        resultado,
      );

      porcentajeEtapa.value = porcentaje;
    } catch (e) {
      error.value = e
          .toString()
          .replaceFirst('Exception: ', '');

      debugPrint(
        '[AVANCE_CONTROLLER] Error cargando avances: $e',
      );
    } finally {
      cargando.value = false;
    }
  }

  // ==========================================================
  // CARGAR AVANCES DE PROYECTO
  // ==========================================================

  Future<List<Map<String, dynamic>>> cargarAvancesPorProyecto(
    int idProyecto,
  ) async {
    cargando.value = true;
    error.value = null;

    try {
      final resultado = await _getAvancesByProject(
        idProyecto,
      );

      avances.assignAll(
        resultado,
      );

      return resultado;
    } catch (e) {
      error.value = e
          .toString()
          .replaceFirst('Exception: ', '');

      debugPrint(
        '[AVANCE_CONTROLLER] Error cargando avances del proyecto: $e',
      );

      return [];
    } finally {
      cargando.value = false;
    }
  }

  // ==========================================================
  // CREAR AVANCE
  // ==========================================================

  Future<Map<String, dynamic>?> crearAvance({
    required int idEtapa,
    required String comentario,
  }) async {
    if (creando.value) {
      return null;
    }

    if (comentario.trim().isEmpty) {
      Get.snackbar(
        'Comentario obligatorio',
        'Escribe qué se hizo antes de registrar el avance.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return null;
    }

    creando.value = true;
    error.value = null;

    try {
      final avance = Avance(
        idEtapa: idEtapa,
        comentario: comentario.trim(),
        fecha: DateTime.now(),
      );

      final resultado = await _createAvance(
        avance,
      );

      await cargarAvancesPorEtapa(
        idEtapa,
      );

      Get.snackbar(
        'Avance registrado',
        'El progreso de la etapa se actualizó correctamente.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return resultado;
    } catch (e) {
      error.value = e
          .toString()
          .replaceFirst('Exception: ', '');

      Get.snackbar(
        'No se pudo registrar el avance',
        error.value ?? 'Ocurrió un error inesperado.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );

      return null;
    } finally {
      creando.value = false;
    }
  }

  // ==========================================================
  // CONSULTAR AVANCE POR ID
  // ==========================================================

  Future<Map<String, dynamic>?> obtenerAvancePorId(
    int idAvance,
  ) async {
    try {
      return await _getAvanceById(
        idAvance,
      );
    } catch (e) {
      error.value = e
          .toString()
          .replaceFirst('Exception: ', '');

      return null;
    }
  }
}