import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:uncampusconnet/features/solicitudes/data/repositories/solicitud_repository_impl.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/responder_solicitud.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE RESPONDER SOLICITUD');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    print('\n--- LOGIN COMO CREADOR ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    const idSolicitud = 1;

    final datasource =
        SolicitudRemoteDatasource(
      roble: roble,
    );

    final repository =
        SolicitudRepositoryImpl(
      datasource: datasource,
    );

    final responderSolicitud =
        ResponderSolicitud(
      repository: repository,
    );

    print('\n--- LEYENDO SOLICITUD ---');

    final antes =
        await repository.getSolicitudById(
      idSolicitud,
    );

    if (antes == null) {
      throw Exception(
        'No existe la solicitud $idSolicitud.',
      );
    }

    print(
      'Estado actual: ${antes['estado']}',
    );

    print('\n--- ACEPTANDO SOLICITUD ---');

    final resultado =
        await responderSolicitud(
      idSolicitud: idSolicitud,
      nuevoEstado: 'aceptado',
    );

    print(
      'UPDATE realizado correctamente.',
    );

    print(
      'Resultado: $resultado',
    );

    print('\n--- VERIFICANDO ---');

    final despues =
        await repository.getSolicitudById(
      idSolicitud,
    );

    print(
      'Estado final: ${despues?['estado']}',
    );

    print(
      'Fecha respuesta: '
      '${despues?['fecha_respuesta']}',
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