import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/comentario/data/datasources/comentario_remote_datasource.dart';
import 'package:uncampusconnet/features/comentario/data/repositories/comentario_repository_impl.dart';
import 'package:uncampusconnet/features/comentario/domain/entities/comentario.dart';
import 'package:uncampusconnet/features/comentario/domain/usecases/create_comentario.dart';
import 'package:uncampusconnet/features/comentario/domain/usecases/get_comentarios_by_publicacion.dart';

Future<int> obtenerIdUsuarioAutenticado(
  dynamic user,
) async {
  final userId =
      user['userId']?.toString();

  if (userId == null || userId.isEmpty) {
    throw Exception(
      'No se pudo obtener el userId de Roble.',
    );
  }

  final usuarios = await RobleClient.instance.read(
    'usuario',
    filters: {
      'id_autenticador': userId,
    },
  );

  if (usuarios.isEmpty) {
    throw Exception(
      'La cuenta autenticada no tiene perfil en usuario.',
    );
  }

  final idUsuario = int.tryParse(
    usuarios.first['id_usuario'].toString(),
  );

  if (idUsuario == null) {
    throw Exception(
      'El perfil no tiene un id_usuario válido.',
    );
  }

  return idUsuario;
}

Future<void> main() async {
  print('========================================');
  print('TEST DE COMENTARIO');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    // =======================================================
    // LOGIN
    // =======================================================

    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    // =======================================================
    // OBTENER USUARIO AUTENTICADO
    // =======================================================

    print(
      '\n--- OBTENIENDO USUARIO AUTENTICADO ---',
    );

    final authUser =
        await roble.currentUser();

    final idUsuario =
        await obtenerIdUsuarioAutenticado(
      authUser,
    );

    print(
      'id_usuario autenticado: $idUsuario',
    );

    // =======================================================
    // PUBLICACIÓN
    // =======================================================

    const idPublicacion = 1;

    print('\n--- COMPROBANDO PUBLICACION ---');

    final publicaciones = await roble.read(
      'publicacion',
      filters: {
        'id_publicacion': idPublicacion,
      },
    );

    if (publicaciones.isEmpty) {
      throw Exception(
        'No existe la publicación $idPublicacion.',
      );
    }

    print(
      'Publicación encontrada: '
      '${publicaciones.first['titulo']}',
    );

    // =======================================================
    // REPOSITORY
    // =======================================================

    final datasource =
        ComentarioRemoteDatasource(
      roble: roble,
    );

    final repository =
        ComentarioRepositoryImpl(
      datasource: datasource,
    );

    final createComentario =
        CreateComentario(
      repository: repository,
    );

    final getComentarios =
        GetComentariosByPublicacion(
      repository: repository,
    );

    // =======================================================
    // CREAR COMENTARIO
    // =======================================================

    print('\n--- CREANDO COMENTARIO ---');

    final comentario = Comentario(
      idPublicacion: idPublicacion,
      idUsuario: idUsuario,
      contenido:
          'Este es un comentario de prueba.',
      fechaComentario: DateTime.now(),
    );

    final resultado =
        await createComentario(
      comentario,
    );

    print(
      'Comentario creado correctamente.',
    );

    print(
      'Resultado: $resultado',
    );

    final idComentario =
        int.parse(
      resultado['id_comentario'].toString(),
    );

    print(
      'id_comentario: $idComentario',
    );

    // =======================================================
    // LEER COMENTARIOS
    // =======================================================

    print(
      '\n--- LEYENDO COMENTARIOS ---',
    );

    final comentarios =
        await getComentarios(
      idPublicacion,
    );

    print(
      'Cantidad de comentarios de la '
      'publicación $idPublicacion: '
      '${comentarios.length}',
    );

    for (final item in comentarios) {
      print(
        'id_comentario='
        '${item['id_comentario']} '
        '→ usuario='
        '${item['id_usuario']} '
        '→ publicacion='
        '${item['id_publicacion']}',
      );

      print(
        'contenido='
        '${item['contenido']}',
      );

      print(
        'fecha='
        '${item['fecha_comentario']}',
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