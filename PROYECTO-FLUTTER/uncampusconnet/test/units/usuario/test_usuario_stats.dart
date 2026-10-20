import 'package:uncampusconnet/core/database/roble_client.dart';

import 'package:uncampusconnet/core/services/usuario_stats_service.dart';

import 'package:uncampusconnet/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:uncampusconnet/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:uncampusconnet/features/usuario/data/datasources/usuario_remote_data_source_impl.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE ESTADISTICAS DE USUARIO');
  print('========================================');

  final roble = RobleClient.instance;

  final authDataSource = AuthRemoteDataSourceImpl();

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authDataSource,
  );

  try {
    // ======================================================
    // LOGIN
    // ======================================================

    print('\n--- LOGIN ---');

    final authUser = await authRepository.login(
      email: 'registro_prueba_02@correo.com',
      password: 'RegistroPrueba!123',
    );

    print('Login exitoso.');

    print(
      'Roble userId: ${authUser.userId}',
    );

    // ======================================================
    // BUSCAR PERFIL EN USUARIO
    // ======================================================

    print('\n--- BUSCANDO PERFIL EN USUARIO ---');

    final usuarioDataSource =
        UsuarioRemoteDataSourceImpl();

    final usuario =
        await usuarioDataSource.obtenerUsuarioActual(
      authUser.userId,
    );

    if (usuario == null) {
      throw Exception(
        'No existe un perfil en la tabla usuario '
        'para la cuenta autenticada.',
      );
    }

    print('Usuario encontrado.');

    print(
      'id_usuario: ${usuario.idUsuario}',
    );

    print(
      'nombre_usuario: ${usuario.nombreUsuario}',
    );

    // ======================================================
    // MOSTRAR ESTADISTICAS ACTUALES
    // ======================================================

    print('\n--- ESTADISTICAS ACTUALES ---');

    print(
      'numero_proyectos actual: '
      '${usuario.numeroProyectos}',
    );

    print(
      'calificacion_usuario actual: '
      '${usuario.calificacionUsuario}',
    );

    // ======================================================
    // PROYECTOS CREADOS
    // ======================================================

    print('\n--- BUSCANDO PROYECTOS CREADOS ---');

    final proyectosCreados = await roble.read(
      'proyecto',
      filters: {
        'id_creador': usuario.idUsuario,
      },
    );

    print(
      'Cantidad de proyectos creados: '
      '${proyectosCreados.length}',
    );

    for (final proyecto in proyectosCreados) {
      print(
        'id=${proyecto['id_proyecto']} '
        '→ ${proyecto['nombre']}',
      );
    }

    // ======================================================
    // PROYECTOS COMO INTEGRANTE
    // ======================================================

    print('\n--- BUSCANDO PROYECTOS COMO INTEGRANTE ---');

    final integrantes = await roble.read(
      'integrantes',
      filters: {
        'id_usuario': usuario.idUsuario,
      },
    );

    print(
      'Cantidad de relaciones como integrante: '
      '${integrantes.length}',
    );

    for (final integrante in integrantes) {
      print(
        'id_usuario_integrante='
        '${integrante['id_usuario_integrante']} '
        '→ proyecto=${integrante['id_proyecto']}',
      );
    }

    // ======================================================
    // CALCULAR PROYECTOS UNICOS
    // ======================================================

    print('\n--- CALCULANDO PROYECTOS UNICOS ---');

    final Set<int> idsProyectos = {};

    // Proyectos creados
    for (final proyecto in proyectosCreados) {
      final idProyecto = int.tryParse(
        proyecto['id_proyecto'].toString(),
      );

      if (idProyecto != null) {
        idsProyectos.add(idProyecto);
      }
    }

    // Proyectos como integrante
    for (final integrante in integrantes) {
      final idProyecto = int.tryParse(
        integrante['id_proyecto'].toString(),
      );

      if (idProyecto != null) {
        idsProyectos.add(idProyecto);
      }
    }

    final int? numeroProyectosEsperado =
        idsProyectos.isEmpty
            ? null
            : idsProyectos.length;

    print(
      'IDs de proyectos participantes: '
      '${idsProyectos.toList()..sort()}',
    );

    print(
      'numero_proyectos esperado: '
      '${numeroProyectosEsperado ?? 'null'}',
    );

    // ======================================================
    // CALCULAR PROMEDIO ESPERADO
    // ======================================================

    print('\n--- CALCULANDO CALIFICACION ESPERADA ---');

    final todosLosProyectos =
        await roble.read('proyecto');

    final List<double> calificaciones = [];

    for (final proyecto in todosLosProyectos) {
      final idProyecto = int.tryParse(
        proyecto['id_proyecto'].toString(),
      );

      if (idProyecto == null ||
          !idsProyectos.contains(idProyecto)) {
        continue;
      }

      final valor = proyecto['calificacion'];

      if (valor == null) {
        print(
          'Proyecto $idProyecto → '
          'sin calificación',
        );

        continue;
      }

      final calificacion =
          double.tryParse(
        valor.toString(),
      );

      if (calificacion != null) {
        calificaciones.add(
          calificacion,
        );

        print(
          'Proyecto $idProyecto → '
          'calificación=$calificacion',
        );
      }
    }

    double? calificacionEsperada;

    if (calificaciones.isNotEmpty) {
      final suma =
          calificaciones.fold<double>(
        0.0,
        (total, actual) =>
            total + actual,
      );

      final promedio =
          suma / calificaciones.length;

      calificacionEsperada =
          double.parse(
        promedio.toStringAsFixed(2),
      );
    }

    print(
      'calificacion_usuario esperada: '
      '${calificacionEsperada ?? 'null'}',
    );

    // ======================================================
    // EJECUTAR SERVICIO
    // ======================================================

    print(
      '\n--- EJECUTANDO USUARIO STATS SERVICE ---',
    );

    final statsService =
        UsuarioStatsService(
      roble: roble,
    );

    await statsService.sincronizarUsuario(
      usuario.idUsuario,
    );

    print(
      'Estadísticas sincronizadas correctamente.',
    );

    // ======================================================
    // LEER USUARIO ACTUALIZADO
    // ======================================================

    print(
      '\n--- VERIFICANDO DATOS ACTUALIZADOS ---',
    );

    final usuariosActualizados =
        await roble.read(
      'usuario',
      filters: {
        'id_usuario':
            usuario.idUsuario,
      },
    );

    if (usuariosActualizados.isEmpty) {
      throw Exception(
        'No se encontró el usuario después '
        'de sincronizar las estadísticas.',
      );
    }

    final usuarioActualizado =
        Map<String, dynamic>.from(
      usuariosActualizados.first,
    );

    final numeroProyectosActual =
        usuarioActualizado[
                'numero_proyectos'] ==
            null
        ? null
        : int.tryParse(
            usuarioActualizado[
                    'numero_proyectos']
                .toString(),
          );

    final calificacionActualRaw =
        usuarioActualizado[
            'calificacion_usuario'];

    final double? calificacionActual =
        calificacionActualRaw == null
            ? null
            : double.tryParse(
                calificacionActualRaw
                    .toString(),
              );

    // ======================================================
    // RESULTADOS
    // ======================================================

    print('');
    print('========================================');
    print('RESULTADOS');
    print('========================================');

    print(
      'numero_proyectos: '
      'esperado=${numeroProyectosEsperado ?? 'null'} '
      '| actual=${numeroProyectosActual ?? 'null'}',
    );

    print(
      'calificacion_usuario: '
      'esperado=${calificacionEsperada ?? 'null'} '
      '| actual=${calificacionActual ?? 'null'}',
    );

    // ======================================================
    // VALIDAR NUMERO_PROYECTOS
    // ======================================================

    final numeroProyectosCorrecto =
        numeroProyectosEsperado ==
            numeroProyectosActual;

    if (numeroProyectosCorrecto) {
      print(
        '✅ numero_proyectos CORRECTO',
      );
    } else {
      print(
        '❌ numero_proyectos INCORRECTO',
      );
    }

    // ======================================================
    // VALIDAR CALIFICACION
    // ======================================================

    bool calificacionCorrecta;

    if (calificacionEsperada == null &&
        calificacionActual == null) {
      calificacionCorrecta = true;
    } else if (
        calificacionEsperada != null &&
        calificacionActual != null) {
      calificacionCorrecta =
          (calificacionEsperada -
                  calificacionActual)
              .abs() <
          0.001;
    } else {
      calificacionCorrecta = false;
    }

    if (calificacionCorrecta) {
      print(
        '✅ calificacion_usuario CORRECTA',
      );
    } else {
      print(
        '❌ calificacion_usuario INCORRECTA',
      );
    }

    // ======================================================
    // REGISTRO FINAL
    // ======================================================

    print('');
    print(
      '--- REGISTRO FINAL DE USUARIO ---',
    );

    print(
      'id_usuario: '
      '${usuarioActualizado['id_usuario']}',
    );

    print(
      'nombre_usuario: '
      '${usuarioActualizado['nombre_usuario']}',
    );

    print(
      'numero_proyectos: '
      '${usuarioActualizado['numero_proyectos']}',
    );

    print(
      'calificacion_usuario: '
      '${usuarioActualizado['calificacion_usuario']}',
    );

    // ======================================================
    // RESULTADO FINAL
    // ======================================================

    if (numeroProyectosCorrecto &&
        calificacionCorrecta) {
      print('');
      print('========================================');
      print('✅ PRUEBA DE USUARIO SUPERADA');
      print('========================================');
    } else {
      print('');
      print('========================================');
      print('❌ PRUEBA DE USUARIO FALLIDA');
      print('========================================');
    }

    // ======================================================
    // LOGOUT
    // ======================================================

    print('\n--- LOGOUT ---');

    await authRepository.logout();

    print('Logout exitoso.');
  } catch (e, stackTrace) {
    print('');
    print('========================================');
    print('ERROR EN EL TEST');
    print('========================================');

    print(e);

    print('\nStackTrace:');
    print(stackTrace);

    try {
      if (roble.isLoggedIn) {
        await authRepository.logout();
        print('\nLogout de emergencia exitoso.');
      }
    } catch (_) {}
  }
}