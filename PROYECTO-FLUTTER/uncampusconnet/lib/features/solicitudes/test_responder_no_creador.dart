import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:uncampusconnet/features/solicitudes/data/repositories/solicitud_repository_impl.dart';
import 'package:uncampusconnet/features/solicitudes/domain/entities/solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/create_solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/responder_solicitud.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE SEGURIDAD DE SOLICITUDES');
  print('========================================');

  final roble = RobleClient.instance;

  // =========================================================
  // CUENTA QUE NO ES LA CREADORA DEL PROYECTO 2
  // =========================================================
  const correoNoCreador = 'registro_prueba_02@correo.com';
  const passwordNoCreador = 'RegistroPrueba!123';

  // =========================================================
  // PROYECTO Y ROL PARA LA PRUEBA
  // =========================================================
  const idProyecto = 2;

  // Usamos otro proyecto_rol distinto al que usamos antes.
  const idProyectoRol = 2;

  try {
    // =======================================================
    // 1. LOGIN
    // =======================================================
    print('\n--- LOGIN COMO NO CREADOR ---');

    await roble.login(
      email: correoNoCreador,
      password: passwordNoCreador,
    );

    print('Login exitoso.');

    // =======================================================
    // 2. OBTENER USUARIO AUTENTICADO
    // =======================================================
    print('\n--- OBTENIENDO USUARIO AUTENTICADO ---');

    final authUser = await roble.currentUser();

    final userIdAuth =
        authUser['userId']?.toString();

    if (
      userIdAuth == null ||
      userIdAuth.isEmpty
    ) {
      throw Exception(
        'No se pudo obtener el userId de Roble.',
      );
    }

    print(
      'Roble userId: $userIdAuth',
    );

    // =======================================================
    // 3. BUSCAR PERFIL EN USUARIO
    // =======================================================
    print('\n--- BUSCANDO PERFIL EN USUARIO ---');

    final usuarios = await roble.read(
      'usuario',
      filters: {
        'id_autenticador': userIdAuth,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'La cuenta autenticada no tiene un perfil en la tabla usuario.',
      );
    }

    final idUsuario = int.parse(
      usuarios.first['id_usuario'].toString(),
    );

    print(
      'id_usuario autenticado: $idUsuario',
    );

    // =======================================================
    // 4. COMPROBAR PROYECTO
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

    final idCreador = int.parse(
      proyecto['id_creador'].toString(),
    );

    print(
      'id_creador del proyecto: $idCreador',
    );

    if (idCreador == idUsuario) {
      throw Exception(
        'La cuenta utilizada ES el creador del proyecto. '
        'Debes utilizar una cuenta diferente.',
      );
    }

    print(
      'Confirmado: el usuario NO es el creador.',
    );

    // =======================================================
    // 5. COMPROBAR PROYECTO_ROL
    // =======================================================
    print('\n--- COMPROBANDO PROYECTO_ROL ---');

    final proyectoRoles = await roble.read(
      'proyecto_roles',
      filters: {
        'id_proyecto_rol': idProyectoRol,
        'id_proyecto': idProyecto,
      },
    );

    if (proyectoRoles.isEmpty) {
      throw Exception(
        'No existe el proyecto_rol $idProyectoRol '
        'para el proyecto $idProyecto.',
      );
    }

    print(
      'Proyecto-rol encontrado.',
    );

    // =======================================================
    // 6. COMPROBAR SI YA EXISTE UNA SOLICITUD
    // =======================================================
    print(
      '\n--- COMPROBANDO SOLICITUDES EXISTENTES ---',
    );

    final solicitudesExistentes =
        await roble.read(
      'solicitudes',
      filters: {
        'id_usuario': idUsuario,
        'id_proyecto_rol': idProyectoRol,
      },
    );

    if (solicitudesExistentes.isNotEmpty) {
      print(
        'Ya existen solicitudes para este usuario y este rol:',
      );

      for (final solicitud
          in solicitudesExistentes) {
        print(
          'id=${solicitud['id_solicitud']} '
          '→ estado=${solicitud['estado']}',
        );
      }

      throw Exception(
        'Para realizar esta prueba necesitas que no exista '
        'una solicitud previa del usuario para este proyecto_rol.',
      );
    }

    print(
      'No existe una solicitud previa. '
      'Se puede crear una nueva.',
    );

    // =======================================================
    // 7. CREAR SOLICITUD
    // =======================================================
    print('\n--- CREANDO SOLICITUD ---');

    final datasource =
        SolicitudRemoteDatasource(
      roble: roble,
    );

    final repository =
        SolicitudRepositoryImpl(
      datasource: datasource,
    );

    final createSolicitud =
        CreateSolicitud(
      repository: repository,
    );

    final responderSolicitud =
        ResponderSolicitud(
      repository: repository,
    );

    final nuevaSolicitud = Solicitud(
      idProyecto: idProyecto,
      idUsuario: idUsuario,
      estado: 'pendiente',
      fechaEnviada: DateTime.now(),
      fechaRespuesta: null,
      idProyectoRol: idProyectoRol,
    );

    final resultadoCrear =
        await createSolicitud(
      nuevaSolicitud,
    );

    print(
      'Solicitud creada correctamente.',
    );

    print(
      'Resultado: $resultadoCrear',
    );

    final idSolicitud =
        int.parse(
      resultadoCrear['id_solicitud']
          .toString(),
    );

    print(
      'ID de solicitud creada: $idSolicitud',
    );

    // =======================================================
    // 8. VERIFICAR QUE QUEDÓ PENDIENTE
    // =======================================================
    print('\n--- VERIFICANDO ESTADO INICIAL ---');

    final solicitudAntes =
        await repository.getSolicitudById(
      idSolicitud,
    );

    if (solicitudAntes == null) {
      throw Exception(
        'No se pudo recuperar la solicitud creada.',
      );
    }

    print(
      'Estado inicial: '
      '${solicitudAntes['estado']}',
    );

    // =======================================================
    // 9. INTENTAR MODIFICAR COMO NO CREADOR
    // =======================================================
    print(
      '\n--- INTENTANDO ACEPTAR COMO NO CREADOR ---',
    );

    var rechazoCorrecto = false;

    try {
      await responderSolicitud(
        idSolicitud: idSolicitud,
        nuevoEstado: 'aceptado',
      );

      print('\n========================================');
      print('ERROR DE SEGURIDAD');
      print('========================================');

      print(
        'El usuario NO creador pudo modificar la solicitud.',
      );
    } catch (e) {
      rechazoCorrecto = true;

      print(
        'Operación rechazada correctamente.',
      );

      print(
        'Mensaje: $e',
      );
    }

    // =======================================================
    // 10. VERIFICAR QUE SIGUE PENDIENTE
    // =======================================================
    print(
      '\n--- VERIFICANDO ESTADO DESPUÉS DEL INTENTO ---',
    );

    final solicitudDespues =
        await repository.getSolicitudById(
      idSolicitud,
    );

    if (solicitudDespues == null) {
      throw Exception(
        'No se pudo recuperar la solicitud después del intento.',
      );
    }

    final estadoFinal =
        solicitudDespues['estado']
            ?.toString()
            .toLowerCase();

    print(
      'Estado final: $estadoFinal',
    );

    if (
      !rechazoCorrecto ||
      estadoFinal != 'pendiente'
    ) {
      throw Exception(
        'La prueba de seguridad falló.',
      );
    }

    print(
      'La solicitud continúa pendiente.',
    );

    // =======================================================
    // 11. LOGOUT
    // =======================================================
    print('\n--- LOGOUT ---');

    await roble.logout();

    print('Logout exitoso.');

    print('\n========================================');
    print('PRUEBA DE SEGURIDAD SUPERADA');
    print('========================================');

    print(
      'El usuario pudo crear la solicitud, '
      'pero no pudo modificarla porque no es el creador '
      'del proyecto.',
    );

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