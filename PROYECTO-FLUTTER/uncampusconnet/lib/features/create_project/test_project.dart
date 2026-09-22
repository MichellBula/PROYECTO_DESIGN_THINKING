import 'package:uncampusconnet/core/database/roble_client.dart';

import 'data/datasources/project_remote_datasource.dart';
import 'data/repositories/project_repository_impl.dart';
import 'domain/entities/project.dart';
import 'domain/usecases/create_project.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE PROYECTO');
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
    // OBTENER USUARIO AUTENTICADO
    // ======================================================

    print('\n--- USUARIO AUTENTICADO ---');

    final usuarioAuth = await roble.currentUser();

    final idAutenticador =
        usuarioAuth['userId'].toString();

    print('id_autenticador: $idAutenticador');

    // ======================================================
    // BUSCAR PERFIL EN USUARIO
    // ======================================================

    print('\n--- BUSCANDO PERFIL ---');

    final usuarios = await roble.read(
      'usuario',
      filters: {
        'id_autenticador': idAutenticador,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'No existe un perfil en la tabla usuario '
        'para este usuario autenticado.',
      );
    }

    final usuario = Map<String, dynamic>.from(
      usuarios.first,
    );

    final idUsuario = int.parse(
      usuario['id_usuario'].toString(),
    );

    print('id_usuario: $idUsuario');
    print(
      'nombre_usuario: '
      '${usuario['nombre_usuario']}',
    );

    // ======================================================
    // DEPENDENCIAS
    // ======================================================

    final datasource = ProjectRemoteDatasource(
      roble: roble,
    );

    final repository = ProjectRepositoryImpl(
      datasource: datasource,
    );

    final createProject = CreateProject(
      repository: repository,
    );

    // ======================================================
    // CREAR PROYECTO
    // ======================================================

    print('\n--- CREANDO PROYECTO ---');

    final proyecto = Project(
      nombre: 'Proyecto de prueba Roble',
      descripcion:
          'Proyecto creado para probar la tabla proyecto.',
      idCreador: idUsuario,
      idCategoria: 1,
      idTipoProyecto: 1,
      objetivo:
          'Comprobar que la creación de proyectos funciona correctamente.',
      requisitos:
          'Tener un usuario autenticado y un perfil registrado.',
      numIntegrantes: 4,
      docenteAsesor: true,
      estado: 'activo',
    );

    final resultado = await createProject.call(
      proyecto,
    );

    print('Proyecto creado correctamente.');
    print('Resultado: $resultado');

    // ======================================================
    // ID GENERADO
    // ======================================================

    final idProyecto = int.parse(
      resultado['id_proyecto'].toString(),
    );

    print('id_proyecto generado: $idProyecto');

    // ======================================================
    // LEER PROYECTO
    // ======================================================

    print('\n--- LEYENDO PROYECTO ---');

    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'El proyecto fue creado pero no pudo ser encontrado.',
      );
    }

    final proyectoLeido =
        Map<String, dynamic>.from(proyectos.first);

    print('Proyecto encontrado.');
    print('----------------------------------------');
    print(
      'id_proyecto: '
      '${proyectoLeido['id_proyecto']}',
    );
    print(
      'nombre: '
      '${proyectoLeido['nombre']}',
    );
    print(
      'descripcion: '
      '${proyectoLeido['descripcion']}',
    );
    print(
      'id_creador: '
      '${proyectoLeido['id_creador']}',
    );
    print(
      'id_categoria: '
      '${proyectoLeido['id_categoria']}',
    );
    print(
      'id_tipo_proyecto: '
      '${proyectoLeido['id_tipo_proyecto']}',
    );
    print(
      'objetivo: '
      '${proyectoLeido['objetivo']}',
    );
    print(
      'requisitos: '
      '${proyectoLeido['requisitos']}',
    );
    print(
      'num_integrantes: '
      '${proyectoLeido['num_integrantes']}',
    );
    print(
      'docente_asesor: '
      '${proyectoLeido['docente_asesor']}',
    );
    print(
      'estado: '
      '${proyectoLeido['estado']}',
    );
    print('----------------------------------------');

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