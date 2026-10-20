import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/usuario_habilidades/data/datasources/usuario_habilidades_remote_datasource.dart';
import 'package:uncampusconnet/features/usuario_habilidades/data/repositories/usuario_habilidades_repository_impl.dart';
import 'package:uncampusconnet/features/usuario_habilidades/domain/entities/usuario_habilidad.dart';
import 'package:uncampusconnet/features/usuario_habilidades/domain/usecases/create_usuario_habilidad.dart';
import 'package:uncampusconnet/features/usuario_habilidades/domain/usecases/get_habilidades_by_user.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE USUARIO_HABILIDADES');
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

    final habilidades = <int>[
      24,
      25,
      27,
    ];

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

    print('\n--- COMPROBANDO HABILIDADES ---');

    for (final idHabilidad in habilidades) {
      final habilidad = await roble.read(
        'habilidad',
        filters: {
          'id_habilidad': idHabilidad,
        },
      );

      if (habilidad.isEmpty) {
        throw Exception(
          'No existe la habilidad $idHabilidad.',
        );
      }

      print(
        'Habilidad $idHabilidad: '
        '${habilidad.first['nombre_habilidad']}',
      );
    }

    final datasource =
        UsuarioHabilidadesRemoteDatasource(
      roble: roble,
    );

    final repository =
        UsuarioHabilidadesRepositoryImpl(
      datasource: datasource,
    );

    final createUsuarioHabilidad =
        CreateUsuarioHabilidad(
      repository: repository,
    );

    final getHabilidadesByUser =
        GetHabilidadesByUser(
      repository: repository,
    );

    print('\n--- CREANDO RELACIONES ---');

    for (final idHabilidad in habilidades) {
      final usuarioHabilidad =
          UsuarioHabilidad(
        idUsuario: idUsuario,
        idHabilidad: idHabilidad,
      );

      final resultado =
          await createUsuarioHabilidad(
        usuarioHabilidad,
      );

      print(
        'Relación creada: '
        'usuario=$idUsuario '
        '→ habilidad=$idHabilidad',
      );

      print(
        'Resultado: $resultado',
      );
    }

    print('\n--- LEYENDO RELACIONES ---');

    final relaciones =
        await getHabilidadesByUser(
      idUsuario,
    );

    print(
      'Cantidad de habilidades del usuario '
      '$idUsuario: ${relaciones.length}',
    );

    for (final relacion in relaciones) {
      print(
        'id_usuario_habilidades='
        '${relacion['id_usuario_habilidades']} '
        '→ usuario=${relacion['id_usuario']} '
        '→ habilidad=${relacion['id_habilidad']}',
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