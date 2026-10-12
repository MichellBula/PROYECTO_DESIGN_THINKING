import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../models/profile_model.dart';
import '../models/proyecto_participacion_model.dart';

class ProfileRemoteDatasource {
  final RobleApiDataBase roble;

  ProfileRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  Future<ProfileModel?> getProfile(int idUsuario) async {
    final usuarios = await roble.read(
      'usuario',
      filters: {'id_usuario': idUsuario},
    );

    if (usuarios.isEmpty) return null;

    final usuario = Map<String, dynamic>.from(usuarios.first);

    final nombreUsuario =
        usuario['nombre_usuario']?.toString().trim() ?? 'Usuario';
    final correoInstitucional =
        usuario['correo_institucional']?.toString().trim() ?? '';
    final carrera = usuario['carrera']?.toString().trim() ?? '';
    final semestre = usuario['semestre']?.toString().trim() ?? '';

    final numeroProyectosRaw = usuario['numero_proyectos'];
    final calificacionUsuarioRaw = usuario['calificacion_usuario'];

    final int? numeroProyectos = numeroProyectosRaw == null
        ? null
        : int.tryParse(numeroProyectosRaw.toString());

    final double? calificacionUsuario = calificacionUsuarioRaw == null
        ? null
        : double.tryParse(calificacionUsuarioRaw.toString());

    final habilidades = await _getNombresHabilidades(idUsuario);

    return ProfileModel(
      idUsuario: idUsuario,
      nombreUsuario: nombreUsuario,
      correoInstitucional: correoInstitucional,
      carrera: carrera,
      semestre: semestre,
      habilidades: habilidades,
      numeroProyectos: numeroProyectos,
      calificacionUsuario: calificacionUsuario,
    );
  }

  Future<List<String>> _getNombresHabilidades(int idUsuario) async {
    final relaciones = await roble.read(
      'usuario_habilidades',
      filters: {'id_usuario': idUsuario},
    );

    final habilidades = <String>[];

    for (final relacion in relaciones) {
      final idHabilidad =
          int.tryParse(relacion['id_habilidad'].toString());
      if (idHabilidad == null) continue;

      final resultadoHabilidad = await roble.read(
        'habilidad',
        filters: {'id_habilidad': idHabilidad},
      );
      if (resultadoHabilidad.isEmpty) continue;

      final nombre = resultadoHabilidad.first['nombre_habilidad']
          ?.toString()
          .trim();

      if (nombre != null &&
          nombre.isNotEmpty &&
          !habilidades.contains(nombre)) {
        habilidades.add(nombre);
      }
    }

    return habilidades;
  }

  Future<List<ProyectoParticipacion>> getProyectosParticipados(
    int idUsuario,
  ) async {
    final relaciones = await roble.read(
      'integrantes',
      filters: {'id_usuario': idUsuario},
    );

    final proyectos = <ProyectoParticipacion>[];

    for (final relacion in relaciones) {
      final idProyecto =
          int.tryParse(relacion['id_proyecto'].toString());
      final idRol = int.tryParse(relacion['id_rol'].toString());
      if (idProyecto == null) continue;

      final resultadoProyecto = await roble.read(
        'proyecto',
        filters: {'id_proyecto': idProyecto},
      );
      if (resultadoProyecto.isEmpty) continue;

      final proyecto = Map<String, dynamic>.from(resultadoProyecto.first);

      String nombreRol = '';
      if (idRol != null) {
        final resultadoRol = await roble.read(
          'rol',
          filters: {'id_rol': idRol},
        );
        if (resultadoRol.isNotEmpty) {
          nombreRol =
              resultadoRol.first['nombre_rol']?.toString().trim() ?? '';
        }
      }

      proyectos.add(
        ProyectoParticipacion(
          idProyecto: idProyecto,
          nombre: proyecto['nombre']?.toString().trim() ?? 'Sin nombre',
          descripcion:
              proyecto['descripcion']?.toString().trim() ?? '',
          estado: proyecto['estado']?.toString().trim() ?? '',
          rol: nombreRol,
        ),
      );
    }

    return proyectos;
  }
}