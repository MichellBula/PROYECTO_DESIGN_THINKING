import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../models/profile_model.dart';

class ProfileRemoteDatasource {
  final RobleApiDataBase roble;

  ProfileRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  Future<ProfileModel?> getProfile(
    int idUsuario,
  ) async {
    // =====================================================
    // USUARIO
    // =====================================================

    final usuarios = await roble.read(
      'usuario',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    if (usuarios.isEmpty) {
      return null;
    }

    final usuario =
        Map<String, dynamic>.from(
      usuarios.first,
    );

    // =====================================================
    // DATOS BASICOS
    // =====================================================

    final nombreUsuario =
        usuario['nombre_usuario']
                ?.toString()
                .trim() ??
            'Usuario';

    final correoInstitucional =
        usuario['correo_institucional']
                ?.toString()
                .trim() ??
            '';

    final carrera =
        usuario['carrera']
                ?.toString()
                .trim() ??
            '';

    final semestre =
        usuario['semestre']
                ?.toString()
                .trim() ??
            '';

    // =====================================================
    // ESTADISTICAS
    // =====================================================

    final numeroProyectosRaw =
        usuario['numero_proyectos'];

    final calificacionUsuarioRaw =
        usuario['calificacion_usuario'];

    final int? numeroProyectos =
        numeroProyectosRaw == null
            ? null
            : int.tryParse(
                numeroProyectosRaw.toString(),
              );

    final double? calificacionUsuario =
        calificacionUsuarioRaw == null
            ? null
            : double.tryParse(
                calificacionUsuarioRaw.toString(),
              );

    // =====================================================
    // HABILIDADES
    // =====================================================

    final relaciones = await roble.read(
      'usuario_habilidades',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    final habilidades = <String>[];

    for (final relacion in relaciones) {
      final idHabilidad = int.tryParse(
        relacion['id_habilidad'].toString(),
      );

      if (idHabilidad == null) {
        continue;
      }

      final resultadoHabilidad =
          await roble.read(
        'habilidad',
        filters: {
          'id_habilidad': idHabilidad,
        },
      );

      if (resultadoHabilidad.isEmpty) {
        continue;
      }

      final nombreHabilidad =
          resultadoHabilidad.first[
                  'nombre_habilidad']
              ?.toString()
              .trim();

      if (nombreHabilidad != null &&
          nombreHabilidad.isNotEmpty &&
          !habilidades.contains(
            nombreHabilidad,
          )) {
        habilidades.add(
          nombreHabilidad,
        );
      }
    }

    // =====================================================
    // PERFIL COMPLETO
    // =====================================================

    return ProfileModel(
      idUsuario: idUsuario,
      nombreUsuario: nombreUsuario,
      correoInstitucional:
          correoInstitucional,
      carrera: carrera,
      semestre: semestre,
      habilidades: habilidades,

      // Nuevas estadísticas
      numeroProyectos:
          numeroProyectos,
      calificacionUsuario:
          calificacionUsuario,
    );
  }
}