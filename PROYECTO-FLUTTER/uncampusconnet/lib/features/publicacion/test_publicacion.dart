import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/publicacion/data/datasources/publicacion_remote_datasource.dart';
import 'package:uncampusconnet/features/publicacion/data/repositories/publicacion_repository_impl.dart';
import 'package:uncampusconnet/features/publicacion/domain/entities/publicacion.dart';
import 'package:uncampusconnet/features/publicacion/domain/usecases/create_publicacion.dart';
import 'package:uncampusconnet/features/publicacion/domain/usecases/get_publicaciones_by_project.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE PUBLICACION');
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
      'id_creador del proyecto: $idCreador',
    );

    // =======================================================
    // DATASOURCE / REPOSITORY
    // =======================================================

    final datasource =
        PublicacionRemoteDatasource(
      roble: roble,
    );

    final repository =
        PublicacionRepositoryImpl(
      datasource: datasource,
    );

    final createPublicacion =
        CreatePublicacion(
      repository: repository,
    );

    final getPublicaciones =
        GetPublicacionesByProject(
      repository: repository,
    );

    // =======================================================
    // CREAR PUBLICACION
    // =======================================================

    print('\n--- CREANDO PUBLICACION ---');

    final publicacion = Publicacion(
      idProyecto: idProyecto,
      titulo: 'Avance del proyecto',
      contenido:
          'El equipo terminó la primera etapa del desarrollo.',
      fechaPublicacion: DateTime.now(),
    );

    final resultado =
        await createPublicacion(
      publicacion,
    );

    print(
      'Publicación creada correctamente.',
    );

    print(
      'Resultado: $resultado',
    );

    // =======================================================
    // LEER PUBLICACIONES DEL PROYECTO
    // =======================================================

    print(
      '\n--- LEYENDO PUBLICACIONES ---',
    );

    final publicaciones =
        await getPublicaciones(
      idProyecto,
    );

    print(
      'Cantidad de publicaciones del proyecto '
      '$idProyecto: ${publicaciones.length}',
    );

    for (final item in publicaciones) {
      print(
        'id_publicacion='
        '${item['id_publicacion']} '
        '→ id_proyecto='
        '${item['id_proyecto']}',
      );

      print(
        'titulo='
        '${item['titulo']}',
      );

      print(
        'contenido='
        '${item['contenido']}',
      );

      print(
        'fecha_publicacion='
        '${item['fecha_publicacion']}',
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

    print(e);

    print('\nStackTrace:');
    print(stackTrace);
  }
}