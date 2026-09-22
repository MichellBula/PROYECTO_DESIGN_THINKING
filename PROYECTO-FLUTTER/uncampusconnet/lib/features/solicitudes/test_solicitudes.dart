import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:uncampusconnet/features/solicitudes/data/repositories/solicitud_repository_impl.dart';
import 'package:uncampusconnet/features/solicitudes/domain/entities/solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/create_solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/get_mis_solicitudes.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/get_solicitudes_pendientes.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/responder_solicitud.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE SOLICITUDES');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    const idUsuarioPostulante = 2;
    const idUsuarioCreador = 1;

    const idProyecto = 2;
    const idProyectoRol = 1;

    print('\n--- COMPROBANDO USUARIO POSTULANTE ---');

    final usuario = await roble.read(
      'usuario',
      filters: {
        'id_usuario': idUsuarioPostulante,
      },
    );

    if (usuario.isEmpty) {
      throw Exception(
        'No existe el usuario $idUsuarioPostulante.',
      );
    }

    print('Usuario postulante encontrado.');

    print('\n--- COMPROBANDO PROYECTO ---');

    final proyecto = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyecto.isEmpty) {
      throw Exception(
        'No existe el proyecto $idProyecto.',
      );
    }

    print('Proyecto encontrado.');

    print('\n--- COMPROBANDO PROYECTO_ROL ---');

    final proyectoRol = await roble.read(
      'proyecto_roles',
      filters: {
        'id_proyecto_rol': idProyectoRol,
      },
    );

    if (proyectoRol.isEmpty) {
      throw Exception(
        'No existe el proyecto_rol $idProyectoRol.',
      );
    }

    print('Proyecto-rol encontrado.');

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

    final getMisSolicitudes =
        GetMisSolicitudes(
      repository: repository,
    );

    final getSolicitudesPendientes =
        GetSolicitudesPendientes(
      repository: repository,
    );

    final responderSolicitud =
        ResponderSolicitud(
      repository: repository,
    );

    print('\n--- CREANDO SOLICITUD ---');

    final solicitud = Solicitud(
      idProyecto: idProyecto,
      idUsuario: idUsuarioPostulante,
      estado: 'pendiente',
      fechaEnviada: DateTime.now(),
      fechaRespuesta: null,
      idProyectoRol: idProyectoRol,
    );

    final resultadoCrear =
        await createSolicitud(
      solicitud,
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
      '\nID de solicitud creada: '
      '$idSolicitud',
    );

    print('\n--- MIS SOLICITUDES ---');

    final misSolicitudes =
        await getMisSolicitudes(
      idUsuarioPostulante,
    );

    print(
      'Cantidad de solicitudes del usuario '
      '$idUsuarioPostulante: '
      '${misSolicitudes.length}',
    );

    for (final solicitud in misSolicitudes) {
      print(
        'id=${solicitud['id_solicitud']} '
        '→ proyecto=${solicitud['id_proyecto']} '
        '→ proyectoRol=${solicitud['id_proyecto_rol']} '
        '→ estado=${solicitud['estado']}',
      );
    }

    print(
      '\n--- SOLICITUDES PENDIENTES DEL CREADOR ---',
    );

    final pendientes =
        await getSolicitudesPendientes(
      idUsuarioCreador,
    );

    print(
      'Cantidad de solicitudes pendientes: '
      '${pendientes.length}',
    );

    for (final solicitud in pendientes) {
      print(
        'id=${solicitud['id_solicitud']} '
        '→ usuario=${solicitud['id_usuario']} '
        '→ proyecto=${solicitud['id_proyecto']} '
        '→ estado=${solicitud['estado']}',
      );
    }

    print('\n--- ACEPTANDO SOLICITUD ---');

    final resultadoRespuesta =
        await responderSolicitud(
      idSolicitud: idSolicitud,
      nuevoEstado: 'aceptado',
    );

    print(
      'Solicitud respondida correctamente.',
    );

    print(
      'Resultado: $resultadoRespuesta',
    );

    print('\n--- VERIFICANDO ESTADO FINAL ---');

    final solicitudFinal =
        await repository.getSolicitudById(
      idSolicitud,
    );

    print(
      'Estado final: '
      '${solicitudFinal?['estado']}',
    );

    print(
      'Fecha respuesta: '
      '${solicitudFinal?['fecha_respuesta']}',
    );

    print('\n--- LOGOUT ---');

    await roble.logout();

    print('Logout exitoso.');

    print('\n========================================');
    print('TEST FINALIZADO CORRECTAMENTE');
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