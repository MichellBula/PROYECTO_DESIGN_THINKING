import 'package:roble/roble.dart';

class UsuarioStatsService {
  final RobleApiDataBase roble;

  UsuarioStatsService({
    required this.roble,
  });

  Future<void> sincronizarUsuario(int idUsuario) async {
    final proyectosCreados = await roble.read(
      'proyecto',
      filters: {'id_creador': idUsuario},
    );

    final integrantes = await roble.read(
      'integrantes',
      filters: {'id_usuario': idUsuario},
    );

    final Set<int> idsProyectos = {};

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

    final todosLosProyectos = await roble.read('proyecto');

    final List<double> calificaciones = [];

    for (final proyecto in todosLosProyectos) {
      final idProyecto = int.tryParse(
        proyecto['id_proyecto'].toString(),
      );

      if (idProyecto == null ||
          !idsProyectos.contains(idProyecto)) {
        continue;
      }

      final calificacionRaw = proyecto['calificacion'];

      if (calificacionRaw == null) {
        continue;
      }

      final calificacion = double.tryParse(
        calificacionRaw.toString(),
      );

      if (calificacion != null) {
        calificaciones.add(calificacion);
      }
    }

    final int? numeroProyectos =
        idsProyectos.isEmpty ? null : idsProyectos.length;

    double? calificacionUsuario;

    if (calificaciones.isNotEmpty) {
      final suma = calificaciones.fold<double>(
        0.0,
        (total, actual) => total + actual,
      );

      final promedio = suma / calificaciones.length;

      calificacionUsuario = double.parse(
        promedio.toStringAsFixed(2),
      );
    }

    final usuarios = await roble.read(
      'usuario',
      filters: {'id_usuario': idUsuario},
    );

    if (usuarios.isEmpty) {
      throw StateError(
        'No se encontró el usuario con id_usuario=$idUsuario.',
      );
    }

    final usuario = Map<String, dynamic>.from(
      usuarios.first,
    );

    final robleId = usuario['_id']?.toString();

    if (robleId == null || robleId.isEmpty) {
      throw StateError(
        'El usuario $idUsuario no tiene un _id válido de Roble.',
      );
    }

    await roble.update(
      'usuario',
      robleId,
      {
        'numero_proyectos': numeroProyectos,
        'calificacion_usuario': calificacionUsuario,
      },
    );
  }

  Future<void> sincronizarPorProyecto(int idProyecto) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {'id_proyecto': idProyecto},
    );

    if (proyectos.isEmpty) {
      throw StateError(
        'No se encontró el proyecto con id_proyecto=$idProyecto.',
      );
    }

    final proyecto = Map<String, dynamic>.from(
      proyectos.first,
    );

    final Set<int> idsUsuarios = {};

    final idCreador = int.tryParse(
      proyecto['id_creador'].toString(),
    );

    if (idCreador != null) {
      idsUsuarios.add(idCreador);
    }

    final integrantes = await roble.read(
      'integrantes',
      filters: {'id_proyecto': idProyecto},
    );

    for (final integrante in integrantes) {
      final idUsuario = int.tryParse(
        integrante['id_usuario'].toString(),
      );

      if (idUsuario != null) {
        idsUsuarios.add(idUsuario);
      }
    }

    for (final idUsuario in idsUsuarios) {
      await sincronizarUsuario(idUsuario);
    }
  }
}