import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/evento/data/datasources/evento_remote_datasource.dart';
import 'package:uncampusconnet/features/evento/data/repositories/evento_repository_impl.dart';
import 'package:uncampusconnet/features/evento/domain/entities/evento.dart';
import 'package:uncampusconnet/features/evento/domain/usecases/create_evento.dart';
import 'package:uncampusconnet/features/evento/domain/usecases/get_eventos_by_project.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE EVENTO');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    // =======================================================
    // LOGIN COMO CREADOR
    // =======================================================

    print('\n--- LOGIN COMO CREADOR ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    // =======================================================
    // PROYECTO EXISTENTE
    // =======================================================

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

    print('Proyecto encontrado.');

    print(
      'id_creador del proyecto: '
      '$idCreador',
    );

    // =======================================================
    // DATASOURCE / REPOSITORY
    // =======================================================

    final datasource =
        EventoRemoteDatasource(
      roble: roble,
    );

    final repository =
        EventoRepositoryImpl(
      datasource: datasource,
    );

    final createEvento =
        CreateEvento(
      repository: repository,
    );

    final getEventos =
        GetEventosByProject(
      repository: repository,
    );

    // =======================================================
    // CREAR EVENTO 1
    // =======================================================

    print('\n--- CREANDO EVENTO 1 ---');

    final ahora = DateTime.now();

    final fechaInicio1 = DateTime(
      ahora.year,
      ahora.month,
      ahora.day + 1,
      10,
      0,
    );

    final fechaFinal1 = DateTime(
      ahora.year,
      ahora.month,
      ahora.day + 1,
      12,
      0,
    );

    final evento1 = Evento(
      idProyecto: idProyecto,
      nombre: 'Presentación de avance',
      tipoEvento: 'Presentación',
      descripcion:
          'Presentación del avance del proyecto al equipo.',
      fechaInicio: fechaInicio1,
      fechaFinal: fechaFinal1,
    );

    final resultado1 =
        await createEvento(
      evento1,
    );

    print(
      'Evento 1 creado correctamente.',
    );

    print(
      'Resultado: $resultado1',
    );

    // =======================================================
    // CREAR EVENTO 2 (NUEVO - fecha fin 25 de septiembre)
    // =======================================================

    print('\n--- CREANDO EVENTO 2 ---');

    final evento2 = Evento(
      idProyecto: idProyecto,
      nombre: 'Reunión de equipo',
      tipoEvento: 'Reunión',
      descripcion:
          'Reunión para coordinar el avance del proyecto.',
      fechaInicio: DateTime(2026, 9, 23, 10, 0),
      fechaFinal: DateTime(2026, 9, 25, 12, 0),
    );

    final resultado2 =
        await createEvento(
      evento2,
    );

    print(
      'Evento 2 creado correctamente.',
    );

    print(
      'Resultado: $resultado2',
    );

    // =======================================================
    // LEER EVENTOS DEL PROYECTO
    // =======================================================

    print(
      '\n--- LEYENDO EVENTOS ---',
    );

    final eventos =
        await getEventos(
      idProyecto,
    );

    print(
      'Cantidad de eventos del proyecto '
      '$idProyecto: ${eventos.length}',
    );

    for (final item in eventos) {
      print(
        'id_evento='
        '${item['id_evento']} '
        '→ id_proyecto='
        '${item['id_proyecto']}',
      );

      print(
        'nombre='
        '${item['nombre']}',
      );

      print(
        'tipo_evento='
        '${item['tipo_evento']}',
      );

      print(
        'descripcion='
        '${item['descripcion']}',
      );

      print(
        'fecha_inicio='
        '${item['fecha_inicio']}',
      );

      print(
        'fecha_final='
        '${item['fecha_final']}',
      );

      print(
        '_owner='
        '${item['_owner']}',
      );
    }

    // =======================================================
    // LOGOUT
    // =======================================================

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

    print('Error: $e');

    print('\nStackTrace:');
    print(stackTrace);
  }
}