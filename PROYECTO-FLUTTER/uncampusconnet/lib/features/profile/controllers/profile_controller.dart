import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controllers/sesion_controller.dart';
import '../data/datasources/profile_remote_datasource.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/entities/profile.dart';
import '../domain/usecases/get_my_profile.dart';

class ProfileController extends GetxController {
  final SesionController _sesionController =
      Get.find<SesionController>();

  late final GetMyProfile _getMyProfile;

  final cargando = false.obs;

  final perfil = Rxn<Profile>();

  final error = RxnString();

  @override
  void onInit() {
    super.onInit();

    final datasource =
        ProfileRemoteDatasource();

    final repository =
        ProfileRepositoryImpl(
      datasource: datasource,
    );

    _getMyProfile =
        GetMyProfile(
      repository: repository,
    );

    cargarPerfil();
  }

  Future<void> cargarPerfil() async {
    cargando.value = true;
    error.value = null;

    try {
      final idUsuario =
          _sesionController.idUsuario;

      if (idUsuario == null) {
        error.value =
            'No se encontró el usuario autenticado.';
        return;
      }

      final resultado =
          await _getMyProfile(
        idUsuario,
      );

      if (resultado == null) {
        error.value =
            'No se encontró el perfil del usuario.';
        return;
      }

      perfil.value = resultado;
    } catch (e) {
      debugPrint(
        'Error cargando perfil: $e',
      );

      error.value =
          'No fue posible cargar el perfil.';
    } finally {
      cargando.value = false;
    }
  }

  Future<void> recargar() async {
    await cargarPerfil();
  }

  String obtenerIniciales(
    String nombre,
  ) {
    final partes = nombre
        .trim()
        .split(
          RegExp(r'\s+'),
        )
        .where(
          (parte) =>
              parte.isNotEmpty,
        )
        .toList();

    if (partes.isEmpty) {
      return 'U';
    }

    if (partes.length == 1) {
      return partes.first[0]
          .toUpperCase();
    }

    return (
      '${partes.first[0]}'
      '${partes.last[0]}'
    ).toUpperCase();
  }
}