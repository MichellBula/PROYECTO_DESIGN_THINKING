import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/publicacion_likes/data/datasources/publicacion_likes_remote_datasource.dart';
import 'package:uncampusconnet/features/publicacion_likes/data/repositories/publicacion_likes_repository_impl.dart';
import 'package:uncampusconnet/features/publicacion_likes/domain/entities/publicacion_like.dart';
import 'package:uncampusconnet/features/publicacion_likes/domain/usecases/create_publicacion_like.dart';
import 'package:uncampusconnet/features/publicacion_likes/domain/usecases/get_likes_by_publicacion.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE PUBLICACION_LIKES');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    const idUsuario = 3;
    const idPublicacion = 1;

    // =======================================================
    // COMPROBAR USUARIO
    // =======================================================

    print('\n--- COMPROBANDO USUARIO ---');

    final usuario = await roble.read(
      'usuario',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    if (usuario.isEmpty) {
      throw Exception(
        'No existe el usuario $idUsuario.',
      );
    }

    print('Usuario encontrado.');

    // =======================================================
    // COMPROBAR PUBLICACION
    // =======================================================

    print('\n--- COMPROBANDO PUBLICACION ---');

    final publicacion = await roble.read(
      'publicacion',
      filters: {
        'id_publicacion': idPublicacion,
      },
    );

    if (publicacion.isEmpty) {
      throw Exception(
        'No existe la publicación $idPublicacion.',
      );
    }

    print(
      'Publicación encontrada: '
      '${publicacion.first['titulo']}',
    );

    // =======================================================
    // REPOSITORY
    // =======================================================

    final datasource =
        PublicacionLikesRemoteDatasource(
      roble: roble,
    );

    final repository =
        PublicacionLikesRepositoryImpl(
      datasource: datasource,
    );

    final createLike =
        CreatePublicacionLike(
      repository: repository,
    );

    final getLikes =
        GetLikesByPublicacion(
      repository: repository,
    );

    // =======================================================
    // CREAR LIKE
    // =======================================================

    print('\n--- CREANDO LIKE ---');

    final like = PublicacionLike(
      idUsuario: idUsuario,
      idPublicacion: idPublicacion,
    );

    final resultado =
        await createLike(
      like,
    );

    print(
      'Like creado correctamente.',
    );

    print(
      'Resultado: $resultado',
    );

    // =======================================================
    // LEER LIKES
    // =======================================================

    print('\n--- LEYENDO LIKES ---');

    final likes =
        await getLikes(
      idPublicacion,
    );

    print(
      'Cantidad de likes de la publicación '
      '$idPublicacion: ${likes.length}',
    );

    for (final item in likes) {
      print(
        'id_publicacion_likes='
        '${item['id_publicacion_likes']} '
        '→ usuario=${item['id_usuario']} '
        '→ publicacion=${item['id_publicacion']}',
      );
    }

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