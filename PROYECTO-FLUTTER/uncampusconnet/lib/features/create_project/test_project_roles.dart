import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/project_roles_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/data/repositories/project_roles_repository_impl.dart';
import 'package:uncampusconnet/features/create_project/domain/entities/project_role.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE PROYECTO_ROLES');
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

    print('\n--- COMPROBANDO ROLES ---');

    const roles = <int>[
      5,  // Desarrollador
      6,  // Diseñador
      24, // Asistente
    ];

    for (final idRol in roles) {
      final resultado = await roble.read(
        'rol',
        filters: {
          'id_rol': idRol,
        },
      );

      if (resultado.isEmpty) {
        throw Exception(
          'No existe el rol con id $idRol.',
        );
      }

      print(
        'Rol $idRol: ${resultado.first['nombre_rol']}',
      );
    }

    final datasource = ProjectRolesRemoteDatasource(
      roble: roble,
    );

    final repository = ProjectRolesRepositoryImpl(
      datasource: datasource,
    );

    print('\n--- CREANDO RELACIONES ---');

    final cantidades = <int, int>{
      5: 2,
      6: 1,
      24: 1,
    };

    for (final idRol in roles) {
      final projectRole = ProjectRole(
        idProyecto: idProyecto,
        idRol: idRol,
        cantidad: cantidades[idRol]!,
      );

      final resultado =
          await repository.createProjectRole(
        projectRole,
      );

      print(
        'Relación creada: '
        'proyecto=$idProyecto, '
        'rol=$idRol, '
        'cantidad=${cantidades[idRol]}',
      );

      print('Resultado: $resultado');
    }

    print('\n--- LEYENDO RELACIONES ---');

    final relaciones =
        await repository.getRolesByProject(
      idProyecto,
    );

    print(
      'Cantidad de roles relacionados: '
      '${relaciones.length}',
    );

    for (final relacion in relaciones) {
      print(
        'proyecto=${relacion['id_proyecto']} '
        '→ rol=${relacion['id_rol']} '
        '→ cantidad=${relacion['cantidad']}',
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