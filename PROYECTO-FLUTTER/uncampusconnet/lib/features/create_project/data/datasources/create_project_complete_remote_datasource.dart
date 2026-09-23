import 'package:roble/roble.dart';
import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/convocatoria_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/project_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/project_roles_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/project_skills_remote_datasource.dart';
import 'package:uncampusconnet/features/create_project/domain/entities/create_project_request.dart';
import 'package:uncampusconnet/features/create_project/models/convocatoria_model.dart';
import 'package:uncampusconnet/features/create_project/models/project_model.dart';
import 'package:uncampusconnet/features/create_project/models/project_role_model.dart';
import 'package:uncampusconnet/features/create_project/models/project_skill_model.dart';

class CreateProjectCompleteRemoteDatasource {
  final RobleApiDataBase roble;

  final ProjectRemoteDatasource projectDatasource;
  final ProjectRolesRemoteDatasource rolesDatasource;
  final ProjectSkillsRemoteDatasource skillsDatasource;
  final ConvocatoriaRemoteDatasource convocatoriaDatasource;

  CreateProjectCompleteRemoteDatasource({
    RobleApiDataBase? roble,
    ProjectRemoteDatasource? projectDatasource,
    ProjectRolesRemoteDatasource? rolesDatasource,
    ProjectSkillsRemoteDatasource? skillsDatasource,
    ConvocatoriaRemoteDatasource? convocatoriaDatasource,
  }) : roble = roble ?? RobleClient.instance,
       projectDatasource =
           projectDatasource ?? ProjectRemoteDatasource(roble: roble),
       rolesDatasource =
           rolesDatasource ?? ProjectRolesRemoteDatasource(roble: roble),
       skillsDatasource =
           skillsDatasource ?? ProjectSkillsRemoteDatasource(roble: roble),
       convocatoriaDatasource =
           convocatoriaDatasource ?? ConvocatoriaRemoteDatasource(roble: roble);

  // ==========================================================
  // CONFIGURACIÓN
  // ==========================================================

  static const Duration _diasAntesDeCierre = Duration(days: 2);

  // ==========================================================
  // USUARIO AUTENTICADO
  // ==========================================================

  Future<int> _obtenerIdUsuarioAutenticado() async {
    print(
      '[COMPLETE_PROJECT] '
      'Obteniendo usuario autenticado...',
    );

    final user = await roble.currentUser();

    final userId = user['userId']?.toString();

    if (userId == null || userId.isEmpty) {
      throw Exception('No fue posible obtener el usuario autenticado.');
    }

    print(
      '[COMPLETE_PROJECT] '
      'Roble userId: $userId',
    );

    final usuarios = await roble.read(
      'usuario',
      filters: {'id_autenticador': userId},
    );

    if (usuarios.isEmpty) {
      throw Exception('La cuenta autenticada no tiene un perfil registrado.');
    }

    final idUsuario = int.tryParse(usuarios.first['id_usuario'].toString());

    if (idUsuario == null) {
      throw Exception('El perfil autenticado no tiene un id_usuario válido.');
    }

    print(
      '[COMPLETE_PROJECT] '
      'id_usuario autenticado: $idUsuario',
    );

    return idUsuario;
  }

  // ==========================================================
  // RESOLVER IDS
  // ==========================================================

  Future<int> _obtenerIdPorNombre({
    required String tabla,
    required String campoId,
    required String valor,
    required List<String> camposNombre,
  }) async {
    print(
      '[COMPLETE_PROJECT] '
      'Buscando "$valor" en "$tabla"...',
    );

    final registros = await roble.read(tabla);

    final buscado = valor.trim().toLowerCase();

    for (final registro in registros) {
      for (final campo in camposNombre) {
        final contenido = registro[campo]?.toString().trim().toLowerCase();

        if (contenido == buscado) {
          final id = int.tryParse(registro[campoId].toString());

          if (id != null) {
            print(
              '[COMPLETE_PROJECT] '
              '"$valor" → ID $id',
            );

            return id;
          }
        }
      }
    }

    throw Exception('No se encontró "$valor" en la tabla $tabla.');
  }

  // ==========================================================
  // NORMALIZAR FECHAS
  // ==========================================================

  DateTime _inicioDelDia(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  DateTime _finalDelDia(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);
  }

  // ==========================================================
  // CREACIÓN COMPLETA
  // ==========================================================

  Future<Map<String, dynamic>> crearProyectoCompleto(
    CreateProjectRequest request,
  ) async {
    print('');
    print('==================================================');
    print('[COMPLETE_PROJECT] INICIANDO CREACIÓN COMPLETA');
    print('==================================================');

    // ========================================================
    // VALIDACIONES
    // ========================================================

    print('[COMPLETE_PROJECT] Validando información...');

    if (request.nombreProyecto.trim().isEmpty) {
      throw Exception('El nombre del proyecto no puede estar vacío.');
    }

    if (request.descripcion.trim().isEmpty) {
      throw Exception('La descripción no puede estar vacía.');
    }

    if (request.objetivo.trim().isEmpty) {
      throw Exception('El objetivo general no puede estar vacío.');
    }

    if (request.requisitos.trim().isEmpty) {
      throw Exception('Los requisitos no pueden estar vacíos.');
    }

    if (request.roles.isEmpty) {
      throw Exception('Debe existir al menos un rol.');
    }

    if (request.habilidades.isEmpty) {
      throw Exception('Debe existir al menos una habilidad.');
    }

    if (request.tipoProyecto == null || request.tipoProyecto!.trim().isEmpty) {
      throw Exception('Debe seleccionarse el tipo de proyecto.');
    }

    if (request.fechaCierre.isBefore(request.fechaInicio)) {
      throw Exception(
        'La fecha de cierre no puede ser anterior a la fecha de inicio.',
      );
    }

    final diasDuracion = request.fechaCierre
        .difference(request.fechaInicio)
        .inDays;

    if (diasDuracion < 7) {
      throw Exception(
        'La fecha de cierre debe ser mínimo 7 días después de la fecha de inicio.',
      );
    }

    print('[COMPLETE_PROJECT] ✅ Validaciones correctas.');

    // ========================================================
    // USUARIO AUTENTICADO
    // ========================================================

    final idCreador = await _obtenerIdUsuarioAutenticado();

    // ========================================================
    // RESOLVER CATEGORÍA
    // ========================================================

    final idCategoria = await _obtenerIdPorNombre(
      tabla: 'categoria',
      campoId: 'id_categoria',
      valor: request.categoria,
      camposNombre: const ['nombre_categoria', 'categoria', 'nombre'],
    );

    // ========================================================
    // RESOLVER TIPO DE PROYECTO
    // ========================================================

    final idTipoProyecto = await _obtenerIdPorNombre(
      tabla: 'tipo_proyecto',
      campoId: 'id_tipo_proyecto',
      valor: request.tipoProyecto!,
      camposNombre: const ['nombre_tipo_proyecto', 'tipo_proyecto', 'nombre'],
    );

    // ========================================================
    // RESOLVER ROLES
    // ========================================================

    final Map<String, int> idsRoles = {};

    for (final nombreRol in request.roles) {
      idsRoles[nombreRol] = await _obtenerIdPorNombre(
        tabla: 'rol',
        campoId: 'id_rol',
        valor: nombreRol,
        camposNombre: const ['nombre_rol', 'rol', 'nombre'],
      );
    }

    // ========================================================
    // RESOLVER HABILIDADES
    // ========================================================

    final Map<String, int> idsHabilidades = {};

    for (final habilidad in request.habilidades) {
      idsHabilidades[habilidad] = await _obtenerIdPorNombre(
        tabla: 'habilidad',
        campoId: 'id_habilidad',
        valor: habilidad,
        camposNombre: const ['nombre_habilidad', 'habilidad', 'nombre'],
      );
    }

    // ========================================================
    // CALCULAR TOTAL DE INTEGRANTES
    // ========================================================

    int totalIntegrantes = 0;

    for (final nombreRol in request.roles) {
      final cantidad = request.cantidadesPorRol[nombreRol];

      if (cantidad == null || cantidad <= 0) {
        throw Exception(
          'Debes indicar al menos 1 integrante para "$nombreRol".',
        );
      }

      totalIntegrantes += cantidad;
    }

    print(
      '[COMPLETE_PROJECT] '
      'Total de integrantes requeridos: '
      '$totalIntegrantes',
    );

    // ========================================================
    // FECHAS
    // ========================================================

    final fechaInicio = _inicioDelDia(request.fechaInicio);

    final fechaFinal = _finalDelDia(request.fechaCierre);

    final fechaLimiteAbandono = fechaFinal.subtract(_diasAntesDeCierre);

    // ========================================================
    // CREAR PROJECT
    // ========================================================

    print('');
    print(
      '[COMPLETE_PROJECT] '
      '========== 1/4 PROYECTO ==========',
    );

    final project = ProjectModel(
      nombre: request.nombreProyecto.trim(),
      descripcion: request.descripcion.trim(),
      idCreador: idCreador,
      idCategoria: idCategoria,
      idTipoProyecto: idTipoProyecto,
      objetivo: request.objetivo.trim(),
      requisitos: request.requisitos.trim(),
      numIntegrantes: totalIntegrantes,
      docenteAsesor: request.deseaDocente,
      estado: 'activo',
    );

    final proyectoCreado = await projectDatasource.createProject(project);

    final idProyecto = int.parse(proyectoCreado['id_proyecto'].toString());

    print(
      '[COMPLETE_PROJECT] ✅ Proyecto listo. '
      'id_proyecto=$idProyecto',
    );

    // ========================================================
    // CREAR ROLES
    // ========================================================

    print('');
    print(
      '[COMPLETE_PROJECT] '
      '========== 2/4 ROLES ==========',
    );

    for (final nombreRol in request.roles) {
      final idRol = idsRoles[nombreRol]!;

      final cantidad = request.cantidadesPorRol[nombreRol]!;

      print(
        '[COMPLETE_PROJECT] '
        'Creando rol "$nombreRol" '
        '(id=$idRol, cantidad=$cantidad)...',
      );

      final resultado = await rolesDatasource.createProjectRole(
        ProjectRoleModel(
          idProyecto: idProyecto,
          idRol: idRol,
          cantidad: cantidad,
        ),
      );

      print(
        '[COMPLETE_PROJECT] ✅ Rol guardado: '
        '${resultado['id_proyecto_rol']}',
      );
    }

    // ========================================================
    // CREAR HABILIDADES
    // ========================================================

    print('');
    print(
      '[COMPLETE_PROJECT] '
      '========== 3/4 HABILIDADES ==========',
    );

    for (final nombreHabilidad in request.habilidades) {
      final idHabilidad = idsHabilidades[nombreHabilidad]!;

      print(
        '[COMPLETE_PROJECT] '
        'Creando habilidad "$nombreHabilidad" '
        '(id=$idHabilidad)...',
      );

      final resultado = await skillsDatasource.createProjectSkill(
        ProjectSkillModel(idProyecto: idProyecto, idHabilidad: idHabilidad),
      );

      print(
        '[COMPLETE_PROJECT] ✅ Habilidad guardada: '
        '${resultado['id_proyecto_habilidad']}',
      );
    }

    // ========================================================
    // CREAR CONVOCATORIA
    // ========================================================

    print('');
    print(
      '[COMPLETE_PROJECT] '
      '========== 4/4 CONVOCATORIA ==========',
    );

    final resultadoConvocatoria = await convocatoriaDatasource
        .createConvocatoria(
          ConvocatoriaModel(
            idProyecto: idProyecto,
            fechaInicio: fechaInicio,
            fechaFinal: fechaFinal,
            estado: true,
            fechaLimiteDeAbandono: fechaLimiteAbandono,
          ),
        );

    print('[COMPLETE_PROJECT] ✅ Convocatoria guardada.');

    print(
      '[COMPLETE_PROJECT] '
      'Resultado convocatoria: '
      '$resultadoConvocatoria',
    );

    // ========================================================
    // FINAL
    // ========================================================

    print('');
    print('==================================================');
    print('[COMPLETE_PROJECT] ✅ PROYECTO COMPLETO CREADO');
    print('==================================================');

    print('[COMPLETE_PROJECT] id_proyecto: $idProyecto');

    print('[COMPLETE_PROJECT] id_creador: $idCreador');

    print(
      '[COMPLETE_PROJECT] roles: '
      '${request.roles.length}',
    );

    print(
      '[COMPLETE_PROJECT] habilidades: '
      '${request.habilidades.length}',
    );

    print('[COMPLETE_PROJECT] convocatoria: creada');

    return {'proyecto': proyectoCreado, 'id_proyecto': idProyecto};
  }
}
