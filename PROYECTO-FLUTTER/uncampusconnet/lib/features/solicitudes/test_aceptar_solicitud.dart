import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/integrantes/data/datasources/integrante_remote_datasource.dart';
import 'package:uncampusconnet/features/integrantes/data/repositories/integrante_repository_impl.dart';
import 'package:uncampusconnet/features/integrantes/domain/repositories/integrante_repository.dart';
import 'package:uncampusconnet/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:uncampusconnet/features/solicitudes/data/repositories/solicitud_repository_impl.dart';
import 'package:uncampusconnet/features/solicitudes/domain/entities/solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/repositories/solicitud_repository.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/aceptar_solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/create_solicitud.dart';

Future<void> main() async {
  print('========================================');
  print('TEST SOLICITUD → INTEGRANTE');
  print('========================================');

  final roble = RobleClient.instance;

  // =========================================================
  // CUENTA DEL POSTULANTE
  //
  // Debe ser una cuenta que:
  // - tenga perfil en usuario
  // - NO sea creadora del proyecto 2
  // - NO sea ya integrante del proyecto 2
  // =========================================================

  const correoPostulante =
      'registro_prueba_01@correo.com';

  const passwordPostulante =
      'RegistroPrueba!123';

  // =========================================================
  // CUENTA DEL CREADOR
  // =========================================================

  const correoCreador =
      'prueba@correo.com';

  const passwordCreador =
      'Prueba123!';

  const idProyecto = 2;

  try {
    // =======================================================
    // 1. LOGIN POSTULANTE
    // =======================================================

    print('\n--- LOGIN COMO POSTULANTE ---');

    await roble.login(
      email: correoPostulante,
      password: passwordPostulante,
    );

    print('Login del postulante exitoso.');

    // =======================================================
    // 2. OBTENER ID DEL POSTULANTE
    // =======================================================

    print(
      '\n--- OBTENIENDO PERFIL DEL POSTULANTE ---',
    );

    final authUser =
        await roble.currentUser();

    final userIdAuth =
        authUser['userId']?.toString();

    if (
      userIdAuth == null ||
      userIdAuth.isEmpty
    ) {
      throw Exception(
        'No se pudo obtener el userId del postulante.',
      );
    }

    final usuarios = await roble.read(
      'usuario',
      filters: {
        'id_autenticador': userIdAuth,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'El postulante no tiene perfil en usuario.',
      );
    }

    final idUsuarioPostulante =
        int.parse(
      usuarios.first['id_usuario'].toString(),
    );

    print(
      'id_usuario postulante: '
      '$idUsuarioPostulante',
    );

    // =======================================================
    // 3. COMPROBAR PROYECTO
    // =======================================================

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
        int.parse(
      proyecto['id_creador'].toString(),
    );

    print(
      'id_creador del proyecto: '
      '$idCreador',
    );

    if (idCreador ==
        idUsuarioPostulante) {
      throw Exception(
        'La cuenta del postulante es también el creador. '
        'Debes usar otra cuenta.',
      );
    }

    // =======================================================
    // 4. BUSCAR UN ROL CON CUPO
    // =======================================================

    print('\n--- BUSCANDO ROL DISPONIBLE ---');

    final proyectoRoles = await roble.read(
      'proyecto_roles',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectoRoles.isEmpty) {
      throw Exception(
        'El proyecto no tiene roles configurados.',
      );
    }

    final integrantesActuales =
        await roble.read(
      'integrantes',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    int? idProyectoRolSeleccionado;
    int? idRolSeleccionado;

    for (final proyectoRol
        in proyectoRoles) {
      final idProyectoRol =
          int.tryParse(
        proyectoRol['id_proyecto_rol']
            .toString(),
      );

      final idRol =
          int.tryParse(
        proyectoRol['id_rol'].toString(),
      );

      final cantidad =
          int.tryParse(
        proyectoRol['cantidad'].toString(),
      );

      if (
        idProyectoRol == null ||
        idRol == null ||
        cantidad == null
      ) {
        continue;
      }

      final ocupados =
          integrantesActuales.where(
        (integrante) {
          return integrante['id_rol']
                  ?.toString() ==
              idRol.toString();
        },
      ).length;

      if (ocupados >= cantidad) {
        continue;
      }

      final solicitudesExistentes =
          await roble.read(
        'solicitudes',
        filters: {
          'id_usuario':
              idUsuarioPostulante,
          'id_proyecto_rol':
              idProyectoRol,
        },
      );

      if (solicitudesExistentes
          .isNotEmpty) {
        continue;
      }

      idProyectoRolSeleccionado =
          idProyectoRol;

      idRolSeleccionado = idRol;

      print(
        'Rol disponible encontrado: '
        'id_proyecto_rol='
        '$idProyectoRolSeleccionado, '
        'id_rol=$idRolSeleccionado, '
        'cupo=$cantidad, '
        'ocupados=$ocupados',
      );

      break;
    }

    if (
      idProyectoRolSeleccionado ==
          null ||
      idRolSeleccionado == null
    ) {
      throw Exception(
        'No se encontró un rol disponible para realizar la prueba.',
      );
    }

    // =======================================================
    // 5. CREAR SOLICITUD
    // =======================================================

    print('\n--- CREANDO SOLICITUD ---');

    final solicitudDatasource =
        SolicitudRemoteDatasource(
      roble: roble,
    );

    final solicitudRepository =
        SolicitudRepositoryImpl(
      datasource: solicitudDatasource,
    );

    final createSolicitud =
        CreateSolicitud(
      repository: solicitudRepository,
    );

    final solicitud = Solicitud(
      idProyecto: idProyecto,
      idUsuario: idUsuarioPostulante,
      estado: 'pendiente',
      fechaEnviada: DateTime.now(),
      fechaRespuesta: null,
      idProyectoRol:
          idProyectoRolSeleccionado,
    );

    final resultadoSolicitud =
        await createSolicitud(
      solicitud,
    );

    final idSolicitud =
        int.parse(
      resultadoSolicitud[
        'id_solicitud'
      ].toString(),
    );

    print(
      'Solicitud creada: '
      'id=$idSolicitud',
    );

    print(
      'estado=${resultadoSolicitud['estado']}',
    );

    // =======================================================
    // 6. LOGOUT DEL POSTULANTE
    // =======================================================

    print(
      '\n--- LOGOUT DEL POSTULANTE ---',
    );

    await roble.logout();

    print('Logout exitoso.');

    // =======================================================
    // 7. LOGIN COMO CREADOR
    // =======================================================

    print('\n--- LOGIN COMO CREADOR ---');

    await roble.login(
      email: correoCreador,
      password: passwordCreador,
    );

    print('Login del creador exitoso.');

    // =======================================================
    // 8. CREAR REPOSITORIO DE INTEGRANTES
    // =======================================================

    final integranteDatasource =
        IntegranteRemoteDatasource(
      roble: roble,
    );

    final IntegranteRepository
        integranteRepository =
        IntegranteRepositoryImpl(
      datasource: integranteDatasource,
    );

    // =======================================================
    // 9. CREAR CASO DE USO ACEPTAR
    // =======================================================

    final aceptarSolicitud =
        AceptarSolicitud(
      solicitudRepository:
          solicitudRepository,
      integranteRepository:
          integranteRepository,
    );

    // =======================================================
    // 10. ACEPTAR SOLICITUD
    // =======================================================

    print(
      '\n--- ACEPTANDO SOLICITUD ---',
    );

    final resultadoAceptar =
        await aceptarSolicitud(
      idSolicitud,
    );

    print(
      'Solicitud aceptada correctamente.',
    );

    print(
      'Resultado solicitud: '
      '${resultadoAceptar['solicitud']}',
    );

    print(
      'Resultado integrante: '
      '${resultadoAceptar['integrante']}',
    );

    // =======================================================
    // 11. VERIFICAR SOLICITUD
    // =======================================================

    print(
      '\n--- VERIFICANDO SOLICITUD ---',
    );

    final solicitudFinal =
        await solicitudRepository
            .getSolicitudById(
      idSolicitud,
    );

    if (solicitudFinal == null) {
      throw Exception(
        'No se pudo encontrar la solicitud después de aceptarla.',
      );
    }

    print(
      'Estado final solicitud: '
      '${solicitudFinal['estado']}',
    );

    if (
      solicitudFinal['estado']
              ?.toString()
              .toLowerCase() !=
          'aceptado'
    ) {
      throw Exception(
        'La solicitud no terminó en estado aceptado.',
      );
    }

    // =======================================================
    // 12. VERIFICAR INTEGRANTE
    // =======================================================

    print(
      '\n--- VERIFICANDO INTEGRANTE ---',
    );

    final integranteFinal =
        await integranteRepository
            .getIntegranteByUserAndProject(
      idUsuario:
          idUsuarioPostulante,
      idProyecto: idProyecto,
    );

    if (integranteFinal == null) {
      throw Exception(
        'No se creó el integrante.',
      );
    }

    print(
      'Integrante encontrado.',
    );

    print(
      'id_usuario_integrante='
      '${integranteFinal['id_usuario_integrante']}',
    );

    print(
      'id_usuario='
      '${integranteFinal['id_usuario']}',
    );

    print(
      'id_proyecto='
      '${integranteFinal['id_proyecto']}',
    );

    print(
      'id_rol='
      '${integranteFinal['id_rol']}',
    );

    // =======================================================
    // 13. LOGOUT
    // =======================================================

    print('\n--- LOGOUT ---');

    await roble.logout();

    print('Logout exitoso.');

    print('\n========================================');
    print('PRUEBA SOLICITUD → INTEGRANTE SUPERADA');
    print('========================================');
  } catch (e, stackTrace) {
    print('\n========================================');
    print('ERROR EN EL TEST');
    print('========================================');

    print(e);

    print('\nStackTrace:');
    print(stackTrace);
  }
}