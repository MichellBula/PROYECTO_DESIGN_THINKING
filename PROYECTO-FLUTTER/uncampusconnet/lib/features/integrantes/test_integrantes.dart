import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/integrantes/data/datasources/integrante_remote_datasource.dart';
import 'package:uncampusconnet/features/integrantes/data/repositories/integrante_repository_impl.dart';
import 'package:uncampusconnet/features/integrantes/domain/entities/integrante.dart';
import 'package:uncampusconnet/features/integrantes/domain/usercases/create_integrante.dart';
import 'package:uncampusconnet/features/integrantes/domain/usercases/get_integrantes_by_project.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE INTEGRANTES');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    print('\n--- LOGIN ---');

    await roble.login(email: 'prueba@correo.com', password: 'Prueba123!');

    print('Login exitoso.');

    const idProyecto = 2;
    const idRol = 6;

    print('\n--- OBTENIENDO ID DEL USUARIO AUTENTICADO ---');

    final authUser = await roble.currentUser();
    final userId = authUser['userId'].toString();

    print('userId de Roble Auth: $userId');

    final usuarios = await roble.read(
      'usuario',
      filters: {'id_autenticador': userId},
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'No existe perfil en tabla usuario para este auth user.',
      );
    }

    final idUsuario = int.parse(
      usuarios.first['id_usuario'].toString(),
    );

    print('id_usuario en tabla usuario: $idUsuario');

    print('\n--- COMPROBANDO PROYECTO ---');

    final proyecto = await roble.read(
      'proyecto',
      filters: {'id_proyecto': idProyecto},
    );

    if (proyecto.isEmpty) {
      throw Exception('No existe el proyecto $idProyecto.');
    }

    print('Proyecto encontrado.');

    print('\n--- COMPROBANDO ROL ---');

    final rol = await roble.read('rol', filters: {'id_rol': idRol});

    if (rol.isEmpty) {
      throw Exception('No existe el rol $idRol.');
    }

    print(
      'Rol encontrado: '
      '${rol.first['nombre_rol']}',
    );

    final datasource = IntegranteRemoteDatasource(roble: roble);

    final repository = IntegranteRepositoryImpl(datasource: datasource);

    final createIntegrante = CreateIntegrante(repository: repository);

    final getIntegrantes = GetIntegrantesByProject(repository: repository);

    print('\n--- CREANDO INTEGRANTE ---');

    final integrante = Integrante(
      idUsuario: idUsuario,
      idProyecto: idProyecto,
      idRol: idRol,
    );

    try {
      final resultado = await createIntegrante(integrante);
      print('Integrante creado correctamente.');
      print('Resultado: $resultado');
    } catch (e) {
      print('No se pudo crear el integrante (puede que ya exista):');
      print(e);
    }

    print('\n--- LEYENDO INTEGRANTES ---');

    final integrantes = await getIntegrantes(idProyecto);

    print(
      'Cantidad de integrantes del proyecto '
      '$idProyecto: ${integrantes.length}',
    );

    for (final item in integrantes) {
      print(
        'id_usuario_integrante='
        '${item['id_usuario_integrante']} '
        '→ usuario=${item['id_usuario']} '
        '→ proyecto=${item['id_proyecto']} '
        '→ rol=${item['id_rol']}',
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