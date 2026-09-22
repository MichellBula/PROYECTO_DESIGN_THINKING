import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/convocatoria_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/data/repositories/convocatoria_repository_impl.dart';
import 'package:uncampusconnet/features/create_project/domain/entities/convocatoria.dart';
import 'package:uncampusconnet/features/create_project/domain/usecases/create_convocatoria.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE CONVOCATORIA');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    const idProyecto = 2;

    print('\n--- COMPROBANDO PROYECTO ---');

    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'No existe el proyecto con id $idProyecto.',
      );
    }

    print('Proyecto encontrado.');

    final datasource =
        ConvocatoriaRemoteDatasource(
      roble: roble,
    );

    final repository =
        ConvocatoriaRepositoryImpl(
      datasource: datasource,
    );

    final createConvocatoria =
        CreateConvocatoria(
      repository: repository,
    );

    print('\n--- CREANDO CONVOCATORIA ---');

    final ahora = DateTime.now();

    final fechaInicio = DateTime(
      ahora.year,
      ahora.month,
      ahora.day + 1,
      8,
      0,
    );

    final fechaFinal = DateTime(
      ahora.year,
      ahora.month,
      ahora.day + 10,
      23,
      59,
    );

    final fechaLimiteDeAbandono = DateTime(
      ahora.year,
      ahora.month,
      ahora.day + 8,
      23,
      59,
    );

    final convocatoria = Convocatoria(
      idProyecto: idProyecto,
      fechaInicio: fechaInicio,
      fechaFinal: fechaFinal,
      estado: true,
      fechaLimiteDeAbandono:
          fechaLimiteDeAbandono,
    );

    final resultado =
        await createConvocatoria(
      convocatoria,
    );

    print('Convocatoria creada.');
    print('Resultado: $resultado');

    print('\n--- LEYENDO CONVOCATORIA ---');

    final convocatoriaLeida =
        await repository.getConvocatoriaByProject(
      idProyecto,
    );

    if (convocatoriaLeida == null) {
      throw Exception(
        'No se encontró la convocatoria.',
      );
    }

    print(
      'id_proyecto: '
      '${convocatoriaLeida['id_proyecto']}',
    );

    print(
      'fecha_inicio: '
      '${convocatoriaLeida['fecha_inicio']}',
    );

    print(
      'fecha_final: '
      '${convocatoriaLeida['fecha_final']}',
    );

    print(
      'estado: '
      '${convocatoriaLeida['estado']}',
    );

    print(
      'fecha_limite_de_abandono: '
      '${convocatoriaLeida['fecha_limite_de_abandono']}',
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