import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/project_skills_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/data/repositories/project_skills_repository_impl.dart';
import 'package:uncampusconnet/features/create_project/domain/entities/project_skill.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE PROYECTO_HABILIDADES');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    // ======================================================
    // LOGIN
    // ======================================================

    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    // ======================================================
    // COMPROBAR PROYECTO
    // ======================================================

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

    // ======================================================
    // COMPROBAR HABILIDADES
    // ======================================================

    const habilidades = [
      24, // Programación
      25, // Desarrollo web
      27, // Bases de datos
    ];

    print('\n--- COMPROBANDO HABILIDADES ---');

    for (final idHabilidad in habilidades) {
      final resultado = await roble.read(
        'habilidad',
        filters: {
          'id_habilidad': idHabilidad,
        },
      );

      if (resultado.isEmpty) {
        throw Exception(
          'No existe la habilidad con id $idHabilidad.',
        );
      }

      print(
        'Habilidad $idHabilidad: '
        '${resultado.first['nombre_habilidad']}',
      );
    }

    // ======================================================
    // DEPENDENCIAS
    // ======================================================

    final datasource =
        ProjectSkillsRemoteDatasource(
      roble: roble,
    );

    final repository =
        ProjectSkillsRepositoryImpl(
      datasource: datasource,
    );

    // ======================================================
    // CREAR RELACIONES
    // ======================================================

    print('\n--- CREANDO RELACIONES ---');

    for (final idHabilidad in habilidades) {
      final projectSkill = ProjectSkill(
        idProyecto: idProyecto,
        idHabilidad: idHabilidad,
      );

      final resultado =
          await repository.createProjectSkill(
        projectSkill,
      );

      print(
        'Relación creada: '
        'proyecto=$idProyecto, '
        'habilidad=$idHabilidad',
      );

      print('Resultado: $resultado');
    }

    // ======================================================
    // LEER RELACIONES
    // ======================================================

    print('\n--- LEYENDO RELACIONES ---');

    final relaciones =
        await repository.getSkillsByProject(
      idProyecto,
    );

    print(
      'Cantidad de habilidades relacionadas: '
      '${relaciones.length}',
    );

    for (final relacion in relaciones) {
      print(
        'proyecto=${relacion['id_proyecto']} '
        '→ '
        'habilidad=${relacion['id_habilidad']}',
      );
    }

    // ======================================================
    // LOGOUT
    // ======================================================

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