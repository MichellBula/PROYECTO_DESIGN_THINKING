import 'package:roble/roble.dart';
import 'package:uncampusconnet/core/database/roble_client.dart';

import 'package:uncampusconnet/features/buscar/data/information_list.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/convocatoria_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/project_roles_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/project_skills_remote_datasource.dart';
import 'package:uncampusconnet/features/usuario/data/datasources/usuario_remote_data_source.dart';
import 'package:uncampusconnet/features/usuario/data/datasources/usuario_remote_data_source_impl.dart';

class BuscarRemoteDatasource {
  final RobleApiDataBase roble;
  final ConvocatoriaRemoteDatasource convocatoriaDatasource;
  final ProjectRolesRemoteDatasource rolesDatasource;
  final ProjectSkillsRemoteDatasource skillsDatasource;
  final UsuarioRemoteDataSource usuarioDatasource;

  BuscarRemoteDatasource({
    RobleApiDataBase? roble,
    ConvocatoriaRemoteDatasource? convocatoriaDatasource,
    ProjectRolesRemoteDatasource? rolesDatasource,
    ProjectSkillsRemoteDatasource? skillsDatasource,
    UsuarioRemoteDataSource? usuarioDatasource,
  }) : roble = roble ?? RobleClient.instance,
       convocatoriaDatasource =
           convocatoriaDatasource ??
           ConvocatoriaRemoteDatasource(roble: roble ?? RobleClient.instance),
       rolesDatasource =
           rolesDatasource ??
           ProjectRolesRemoteDatasource(roble: roble ?? RobleClient.instance),
       skillsDatasource =
           skillsDatasource ??
           ProjectSkillsRemoteDatasource(roble: roble ?? RobleClient.instance),
       usuarioDatasource = usuarioDatasource ?? UsuarioRemoteDataSourceImpl();

  // ==========================================================
  // OBTENER TODOS LOS PROYECTOS
  // ==========================================================

  Future<List<ProjectInfo>> getProjects() async {
    print('');
    print('==================================================');
    print('[BUSCAR] INICIANDO CARGA DE PROYECTOS');
    print('==================================================');

    // ----------------------------------------------------------
    // 1. PROYECTOS
    // ----------------------------------------------------------

    print('[BUSCAR] Consultando tabla "proyecto"...');

    final proyectos = await roble.read('proyecto');

    print('[BUSCAR] Proyectos encontrados: ${proyectos.length}');

    // ----------------------------------------------------------
    // 2. CATÁLOGOS
    // ----------------------------------------------------------

    print('[BUSCAR] Consultando catálogo de categorías...');

    final categorias = await roble.read('categoria');

    print('[BUSCAR] Categorías encontradas: ${categorias.length}');

    print('[BUSCAR] Consultando catálogo de roles...');

    final rolesCatalogo = await roble.read('rol');

    print('[BUSCAR] Roles encontrados: ${rolesCatalogo.length}');

    print('[BUSCAR] Consultando catálogo de habilidades...');

    final habilidadesCatalogo = await roble.read('habilidad');

    print(
      '[BUSCAR] Habilidades encontradas: '
      '${habilidadesCatalogo.length}',
    );

    // ----------------------------------------------------------
    // 3. MAPAS DE CATÁLOGOS
    // ----------------------------------------------------------

    final categoriasPorId = <int, String>{};

    for (final categoria in categorias) {
      final id = _toInt(categoria['id_categoria']);

      final nombre = categoria['nombre_categoria']?.toString().trim();

      if (id != null && nombre != null && nombre.isNotEmpty) {
        categoriasPorId[id] = nombre;
      }
    }

    final rolesPorId = <int, String>{};

    for (final rol in rolesCatalogo) {
      final id = _toInt(rol['id_rol']);

      final nombre = rol['nombre_rol']?.toString().trim();

      if (id != null && nombre != null && nombre.isNotEmpty) {
        rolesPorId[id] = nombre;
      }
    }

    final habilidadesPorId = <int, String>{};

    for (final habilidad in habilidadesCatalogo) {
      final id = _toInt(habilidad['id_habilidad']);

      final nombre = habilidad['nombre_habilidad']?.toString().trim();

      if (id != null && nombre != null && nombre.isNotEmpty) {
        habilidadesPorId[id] = nombre;
      }
    }

    // ----------------------------------------------------------
    // 4. CONSTRUIR RESULTADO
    // ----------------------------------------------------------

    final resultado = <ProjectInfo>[];

    for (final proyecto in proyectos) {
      try {
        final idProyecto = _toInt(proyecto['id_proyecto']);

        final idCreador = _toInt(proyecto['id_creador']);

        final idCategoria = _toInt(proyecto['id_categoria']);

        if (idProyecto == null) {
          print(
            '[BUSCAR] ⚠️ Proyecto ignorado: '
            'no tiene id_proyecto válido.',
          );

          continue;
        }

        print('');
        print('[BUSCAR] ------------------------------------------');
        print('[BUSCAR] Procesando proyecto id=$idProyecto');

        print(
          '[BUSCAR] Nombre: '
          '${proyecto['nombre']}',
        );

        // ======================================================
        // LIDER
        // ======================================================

        String leader = 'Usuario';

        if (idCreador != null) {
          print(
            '[BUSCAR] Buscando creador '
            'id_usuario=$idCreador...',
          );

          final usuario = await usuarioDatasource.obtenerUsuarioPorId(
            idCreador,
          );

          if (usuario != null) {
            leader = usuario.nombreUsuario;
          }
        }

        if (!leader.startsWith('@')) {
          leader = '@$leader';
        }

        print('[BUSCAR] Líder: $leader');

        // ======================================================
        // CATEGORIA
        // ======================================================

        String area = 'Sin categoría';

        if (idCategoria != null) {
          area = categoriasPorId[idCategoria] ?? 'Sin categoría';
        }

        print('[BUSCAR] Categoría: $area');

        // ======================================================
        // CONVOCATORIA
        // ======================================================

        print(
          '[BUSCAR] Buscando convocatoria '
          'del proyecto $idProyecto...',
        );

        final convocatoria = await convocatoriaDatasource
            .getConvocatoriaByProject(idProyecto);

        String closingDate = '';

        if (convocatoria != null) {
          final fecha = DateTime.tryParse(
            convocatoria['fecha_final']?.toString() ?? '',
          );

          if (fecha != null) {
            closingDate = _formatDate(fecha.toLocal());
          }
        }

        print(
          '[BUSCAR] Fecha cierre: '
          '${closingDate.isEmpty ? 'No disponible' : closingDate}',
        );

        // ======================================================
        // ROLES
        // ======================================================

        print(
          '[BUSCAR] Buscando roles '
          'del proyecto $idProyecto...',
        );

        final relacionesRoles = await rolesDatasource.getRolesByProject(
          idProyecto,
        );

        final projectRoles = <String>[];

        int vacancies = 0;

        for (final relacion in relacionesRoles) {
          final idRol = _toInt(relacion['id_rol']);

          final cantidad = _toInt(relacion['cantidad']) ?? 0;

          vacancies += cantidad;

          if (idRol == null) {
            continue;
          }

          final nombreRol = rolesPorId[idRol];

          if (nombreRol != null && nombreRol.isNotEmpty) {
            projectRoles.add(nombreRol);
          }
        }

        print(
          '[BUSCAR] Roles encontrados: '
          '${projectRoles.length}',
        );

        print(
          '[BUSCAR] Vacantes configuradas: '
          '$vacancies',
        );

        // ======================================================
        // HABILIDADES
        // ======================================================

        print(
          '[BUSCAR] Buscando habilidades '
          'del proyecto $idProyecto...',
        );

        final relacionesHabilidades = await skillsDatasource.getSkillsByProject(
          idProyecto,
        );

        final habilidades = <String>[];

        for (final relacion in relacionesHabilidades) {
          final idHabilidad = _toInt(relacion['id_habilidad']);

          if (idHabilidad == null) {
            continue;
          }

          final nombreHabilidad = habilidadesPorId[idHabilidad];

          if (nombreHabilidad != null && nombreHabilidad.isNotEmpty) {
            habilidades.add(nombreHabilidad);
          }
        }

        print(
          '[BUSCAR] Habilidades encontradas: '
          '${habilidades.length}',
        );

        // ======================================================
        // REQUISITOS
        // ======================================================

        final requisitosTexto = proyecto['requisitos']?.toString() ?? '';

        final requisitos = requisitosTexto
            .split(RegExp(r'[,;\n]'))
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();

        // ======================================================
        // CREAR PROJECTINFO
        // ======================================================

        final projectInfo = ProjectInfo(
          idProyecto: idProyecto,
          leader: leader,
          name: proyecto['nombre']?.toString() ?? 'Proyecto sin nombre',
          members: proyecto['num_integrantes']?.toString() ?? '0',
          vacancies: vacancies.toString(),
          closingDate: closingDate,
          area: area,
          description: proyecto['descripcion']?.toString() ?? '',
          requirements: requisitos,
          roles: projectRoles,
          keywords: habilidades.join(' '),
        );

        resultado.add(projectInfo);

        print('[BUSCAR] ✅ Proyecto agregado al resultado.');
      } catch (e, stackTrace) {
        print('[BUSCAR] ❌ Error procesando un proyecto.');

        print('[BUSCAR] Error: $e');

        print('[BUSCAR] StackTrace:');

        print(stackTrace);

        // Continuamos con los demás proyectos.
      }
    }

    print('');
    print('==================================================');
    print('[BUSCAR] ✅ CARGA FINALIZADA');
    print(
      '[BUSCAR] Proyectos listos para mostrar: '
      '${resultado.length}',
    );
    print('==================================================');

    return resultado;
  }

  // ==========================================================
  // CONVERTIR A INT
  // ==========================================================

  int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }

  // ==========================================================
  // FORMATEAR FECHA
  // ==========================================================

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');

    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}
