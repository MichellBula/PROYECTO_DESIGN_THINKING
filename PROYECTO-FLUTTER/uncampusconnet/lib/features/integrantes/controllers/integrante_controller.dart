import 'package:get/get.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';

class Participante {
  final String usuario;
  final String rol;

  const Participante({
    required this.usuario,
    required this.rol,
  });
}

class IntegranteController extends GetxController {
  //Estado
  /// Indicador de carga
  final cargando = false.obs;

  /// Lista de participantes
  final participantes = <Participante>[].obs;

  //Cargar participantes
  Future<void> cargarParticipantes(int idProyecto) async {
    cargando.value = true;

    try {
      // 1. Obtener los integrantes del proyecto
      final integrantes = await RobleClient.instance.read(
        'integrantes',
        filters: {'id_proyecto': idProyecto},
      );

      if (integrantes.isEmpty) {
        participantes.clear();
        return;
      }

      // 2. Construir la lista de participantes
      final lista = <Participante>[];

      for (final integrante in integrantes) {
        final idUsuario = int.tryParse(
          integrante['id_usuario'].toString(),
        );
        final idRol = int.tryParse(
          integrante['id_rol'].toString(),
        );

        final nombreUsuario = await _obtenerNombreUsuario(idUsuario);
        final nombreRol = await _obtenerNombreRol(idRol);

        lista.add(
          Participante(
            usuario: '@$nombreUsuario',
            rol: nombreRol,
          ),
        );
      }

      participantes.assignAll(lista);
    } catch (e) {
      participantes.clear();
    } finally {
      cargando.value = false;
    }
  }

  //Helpers
  Future<String> _obtenerNombreUsuario(int? idUsuario) async {
    if (idUsuario == null) return '';

    final usuarios = await RobleClient.instance.read(
      'usuario',
      filters: {'id_usuario': idUsuario},
    );

    if (usuarios.isEmpty) return 'Desconocido';

    return usuarios.first['nombre_usuario']?.toString() ?? 'Desconocido';
  }

  Future<String> _obtenerNombreRol(int? idRol) async {
    if (idRol == null) return '';

    final roles = await RobleClient.instance.read(
      'rol',
      filters: {'id_rol': idRol},
    );

    if (roles.isEmpty) return 'Sin rol';

    return roles.first['nombre_rol']?.toString() ?? 'Sin rol';
  }
}