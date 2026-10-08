import 'package:uncampusconnet/core/database/roble_client.dart';

import 'data/datasources/project_remote_datasource.dart';
import 'data/repositories/project_repository_impl.dart';
import 'domain/usecases/calificar_proyecto.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE CALIFICACION + ESTADISTICAS');
  print('========================================');

  final roble = RobleClient.instance;

  const int idProyecto = 15;
  const double nuevaCalificacion = 3.0;

  try {
    // =====================================================
    // LOGIN COMO CREADOR
    // =====================================================

    print('\n--- LOGIN COMO CREADOR ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    // =====================================================
    // COMPROBAR PROYECTO
    // =====================================================

    print('\n--- COMPROBANDO PROYECTO ---');

    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'No existe el proyecto $idProyecto.',
      );
    }

    final proyecto =
        Map<String, dynamic>.from(
      proyectos.first,
    );

    final idCreador =
        int.tryParse(
      proyecto['id_creador'].toString(),
    );

    if (idCreador == null) {
      throw Exception(
        'El proyecto no tiene un id_creador válido.',
      );
    }

    print(
      'Proyecto encontrado: '
      '${proyecto['nombre']}',
    );

    print(
      'id_proyecto: $idProyecto',
    );

    print(
      'id_creador: $idCreador',
    );

    print(
      'calificación actual: '
      '${proyecto['calificacion']}',
    );

    // =====================================================
    // COMPROBAR QUE EL USUARIO AUTENTICADO SEA EL CREADOR
    // =====================================================

    print(
      '\n--- COMPROBANDO CREADOR ---',
    );

    final authUser =
        await roble.currentUser();

    final idAutenticador =
        authUser['userId']?.toString();

    if (idAutenticador == null ||
        idAutenticador.isEmpty) {
      throw Exception(
        'No se pudo obtener el userId autenticado.',
      );
    }

    final usuarios =
        await roble.read(
      'usuario',
      filters: {
        'id_autenticador':
            idAutenticador,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'No existe perfil para el usuario autenticado.',
      );
    }

    final idUsuarioAutenticado =
        int.parse(
      usuarios.first[
              'id_usuario']
          .toString(),
    );

    print(
      'id_usuario autenticado: '
      '$idUsuarioAutenticado',
    );

    if (idUsuarioAutenticado !=
        idCreador) {
      throw Exception(
        'La cuenta utilizada no es el creador del proyecto.',
      );
    }

    print(
      'Confirmado: el usuario es el creador.',
    );

    // =====================================================
    // COMPROBAR INTEGRANTES
    // =====================================================

    print(
      '\n--- COMPROBANDO INTEGRANTES ---',
    );

    final integrantes =
        await roble.read(
      'integrantes',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    print(
      'Cantidad de integrantes: '
      '${integrantes.length}',
    );

    for (final integrante
        in integrantes) {
      print(
        'usuario=${integrante['id_usuario']} '
        '→ proyecto=${integrante['id_proyecto']}',
      );
    }

    // =====================================================
    // MOSTRAR ESTADISTICAS ANTES
    // =====================================================

    print(
      '\n--- ESTADISTICAS ANTES DE CALIFICAR ---',
    );

    final Set<int> usuariosParticipantes =
        {};

    usuariosParticipantes.add(
      idCreador,
    );

    for (final integrante
        in integrantes) {
      final idUsuario =
          int.tryParse(
        integrante['id_usuario']
            .toString(),
      );

      if (idUsuario != null) {
        usuariosParticipantes.add(
          idUsuario,
        );
      }
    }

    for (final idUsuario
        in usuariosParticipantes) {
      final usuario =
          await roble.read(
        'usuario',
        filters: {
          'id_usuario':
              idUsuario,
        },
      );

      if (usuario.isEmpty) {
        continue;
      }

      print(
        'Usuario $idUsuario → '
        'numero_proyectos='
        '${usuario.first['numero_proyectos']} '
        '| calificacion_usuario='
        '${usuario.first['calificacion_usuario']}',
      );
    }

    // =====================================================
    // CREAR DEPENDENCIAS
    // =====================================================

    final datasource =
        ProjectRemoteDatasource(
      roble: roble,
    );

    final repository =
        ProjectRepositoryImpl(
      datasource: datasource,
    );

    final calificarProyecto =
        CalificarProyecto(
      repository: repository,
    );

    // =====================================================
    // CALIFICAR PROYECTO
    // =====================================================

    print(
      '\n--- CALIFICANDO PROYECTO ---',
    );

    final resultado =
        await calificarProyecto(
      idProyecto: idProyecto,
      calificacion:
          nuevaCalificacion,
    );

    print(
      'Calificación actualizada correctamente.',
    );

    print(
      'Resultado: $resultado',
    );

    // =====================================================
    // VERIFICAR CALIFICACION DEL PROYECTO
    // =====================================================

    print(
      '\n--- VERIFICANDO CALIFICACION DEL PROYECTO ---',
    );

    final proyectoActualizado =
        await roble.read(
      'proyecto',
      filters: {
        'id_proyecto':
            idProyecto,
      },
    );

    if (proyectoActualizado.isEmpty) {
      throw Exception(
        'No se pudo volver a leer el proyecto.',
      );
    }

    final calificacionFinal =
        proyectoActualizado.first[
            'calificacion'];

    print(
      'Calificación final del proyecto: '
      '$calificacionFinal',
    );

    // =====================================================
    // VERIFICAR ESTADISTICAS DESPUES
    // =====================================================

    print(
      '\n--- VERIFICANDO ESTADISTICAS DESPUES ---',
    );

    for (final idUsuario
        in usuariosParticipantes) {
      final usuario =
          await roble.read(
        'usuario',
        filters: {
          'id_usuario':
              idUsuario,
        },
      );

      if (usuario.isEmpty) {
        print(
          '⚠️ Usuario $idUsuario no encontrado.',
        );
        continue;
      }

      print('');
      print(
        'Usuario $idUsuario',
      );

      print(
        'numero_proyectos: '
        '${usuario.first['numero_proyectos']}',
      );

      print(
        'calificacion_usuario: '
        '${usuario.first['calificacion_usuario']}',
      );
    }

    // =====================================================
    // LOGOUT
    // =====================================================

    print(
      '\n--- LOGOUT ---',
    );

    await roble.logout();

    print('Logout exitoso.');

    // =====================================================
    // FINAL
    // =====================================================

    print(
      '\n========================================',
    );
    print(
      'TEST FINALIZADO CORRECTAMENTE',
    );
    print(
      '========================================',
    );
  } catch (e, stackTrace) {
    print(
      '\n========================================',
    );
    print(
      'ERROR EN EL TEST',
    );
    print(
      '========================================',
    );

    print(e);

    print(
      '\nStackTrace:',
    );

    print(stackTrace);

    try {
      await roble.logout();
    } catch (_) {}
  }
}