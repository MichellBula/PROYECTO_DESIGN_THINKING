import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uncampusconnet/features/etapa/data/datasource/etapa_remote_datasource.dart';

import '../data/repositories/etapa_repository_impl.dart';
import '../domain/entities/etapa.dart';
import '../domain/usecases/create_etapa.dart';
import '../domain/usecases/get_etapa_by_id.dart';
import '../domain/usecases/get_etapas_by_project.dart';

class EtapaController extends GetxController {
  EtapaController({
    EtapaRepositoryImpl? repository,
  }) : repository = repository ??
            EtapaRepositoryImpl(
              datasource: EtapaRemoteDatasource(),
            );

  final EtapaRepositoryImpl repository;

  late final CreateEtapa _createEtapa;
  late final GetEtapaById _getEtapaById;
  late final GetEtapasByProject _getEtapasByProject;

  final cargando = false.obs;
  final creando = false.obs;
  final etapas = <Map<String, dynamic>>[].obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();

    _createEtapa = CreateEtapa(
      repository: repository,
    );

    _getEtapaById = GetEtapaById(
      repository: repository,
    );

    _getEtapasByProject = GetEtapasByProject(
      repository: repository,
    );
  }

  // ==========================================================
  // CARGAR ETAPAS
  // ==========================================================

  Future<void> cargarEtapas(
    int idProyecto,
  ) async {
    cargando.value = true;
    error.value = null;

    try {
      final resultado = await _getEtapasByProject(
        idProyecto,
      );

      etapas.assignAll(
        resultado,
      );
    } catch (e) {
      error.value = e
          .toString()
          .replaceFirst('Exception: ', '');

      debugPrint(
        '[ETAPA_CONTROLLER] Error cargando etapas: $e',
      );
    } finally {
      cargando.value = false;
    }
  }

  // ==========================================================
  // CREAR ETAPA
  // ==========================================================

  Future<Map<String, dynamic>?> crearEtapa({
    required int idProyecto,
    required String nombreEtapa,
    required int orden,
  }) async {
    if (creando.value) {
      return null;
    }

    creando.value = true;
    error.value = null;

    try {
      final etapa = Etapa(
        idProyecto: idProyecto,
        nombreEtapa: nombreEtapa.trim(),
        orden: orden,
      );

      final resultado = await _createEtapa(
        etapa,
      );

      await cargarEtapas(
        idProyecto,
      );

      Get.snackbar(
        'Etapa creada',
        'La etapa se guardó correctamente.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return resultado;
    } catch (e) {
      error.value = e
          .toString()
          .replaceFirst('Exception: ', '');

      Get.snackbar(
        'No se pudo crear la etapa',
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
  // BUSCAR ETAPA POR ID
  // ==========================================================

  Future<Map<String, dynamic>?> obtenerEtapaPorId(
    int idEtapa,
  ) async {
    try {
      return await _getEtapaById(
        idEtapa,
      );
    } catch (e) {
      error.value = e
          .toString()
          .replaceFirst('Exception: ', '');

      return null;
    }
  }
}