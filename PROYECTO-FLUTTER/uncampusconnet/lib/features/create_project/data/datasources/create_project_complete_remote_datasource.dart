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
import 'package:uncampusconnet/features/integrantes/data/datasources/integrante_remote_datasource.dart';

// Datasource que crea un proyecto completo en Roble. Se encarga de guardar el proyecto, sus roles, habilidades, la convocatoria y al creador como líder.
class CreateProjectCompleteRemoteDatasource {
  final RobleApiDataBase roble;
  // Datasources para cada tabla que se necesita
  final ProjectRemoteDatasource projectDatasource;
  final ProjectRolesRemoteDatasource rolesDatasource;
  final ProjectSkillsRemoteDatasource skillsDatasource;
  final ConvocatoriaRemoteDatasource convocatoriaDatasource;
  final IntegranteRemoteDatasource integranteDatasource;

  CreateProjectCompleteRemoteDatasource({
    RobleApiDataBase? roble,
    ProjectRemoteDatasource? projectDatasource,
    ProjectRolesRemoteDatasource? rolesDatasource,
    ProjectSkillsRemoteDatasource? skillsDatasource,
    ConvocatoriaRemoteDatasource? convocatoriaDatasource,
    IntegranteRemoteDatasource? integranteDatasource,
  })  : roble = roble ?? RobleClient.instance,
        projectDatasource =
            projectDatasource ?? ProjectRemoteDatasource(roble: roble),
        rolesDatasource =
            rolesDatasource ?? ProjectRolesRemoteDatasource(roble: roble),
        skillsDatasource =
            skillsDatasource ?? ProjectSkillsRemoteDatasource(roble: roble),
        convocatoriaDatasource =
            convocatoriaDatasource ?? ConvocatoriaRemoteDatasource(roble: roble),
        integranteDatasource =
            integranteDatasource ?? IntegranteRemoteDatasource(roble: roble);

  // Días antes del cierre que se bloquea el abandono
  static const Duration _diasAntesDeCierre = Duration(days: 2);

  // ID del rol Líder en la tabla rol
  static const int _idRolLider = 1;

  // Obtiene el id_usuario del usuario que está logueado
  Future<int> _obtenerIdUsuarioAutenticado() async {
    final user = await roble.currentUser();
    final userId = user['userId']?.toString();

    if (userId == null || userId.isEmpty) {
      throw Exception('No fue posible obtener el usuario autenticado.');
    }

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

    return idUsuario;
  }

  // Busca el id de un registro por su nombre en una tabla
  // Se usa para categorías, tipos de proyecto, roles y habilidades
  Future<int> _obtenerIdPorNombre({
    required String tabla,
    required String campoId,
    required String valor,
    required List<String> camposNombre,
  }) async {
    final registros = await roble.read(tabla);

    final buscado = valor.trim().toLowerCase();

    for (final registro in registros) {
      for (final campo in camposNombre) {
        final contenido = registro[campo]?.toString().trim().toLowerCase();

        if (contenido == buscado) {
          final id = int.tryParse(registro[campoId].toString());

          if (id != null) {
            return id;
          }
        }
      }
    }

    throw Exception('No se encontró "$valor" en la tabla $tabla.');
  }

  // Devuelve la fecha sin hora (00:00:00)
  DateTime _inicioDelDia(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  // Devuelve la fecha con hora final del día (23:59:59)
  DateTime _finalDelDia(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);
  }

  // Agrega al creador del proyecto como integrante con rol Líder
  Future<void> _agregarCreadorComoLider({
    required int idProyecto,
    required int idCreador,
  }) async {
    // Si ya existe como integrante, no se agrega de nuevo
    final existentes = await roble.read(
      'integrantes',
      filters: {
        'id_usuario': idCreador,
        'id_proyecto': idProyecto,
      },
    );

    if (existentes.isNotEmpty) {
      return;
    }

    await integranteDatasource.createIntegranteSimple(
      idUsuario: idCreador,
      idProyecto: idProyecto,
      idRol: _idRolLider,
    );
  }

  // Crea el proyecto completo en Roble
  Future<Map<String, dynamic>> crearProyectoCompleto(
    CreateProjectRequest request,
  ) async {
    // Validaciones de los campos obligatorios
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

    // El proyecto debe durar mínimo 7 días
    final diasDuracion =
        request.fechaCierre.difference(request.fechaInicio).inDays;

    if (diasDuracion < 7) {
      throw Exception(
        'La fecha de cierre debe ser mínimo 7 días después de la fecha de inicio.',
      );
    }

    // Obtener el id del usuario que crea el proyecto
    final idCreador = await _obtenerIdUsuarioAutenticado();

    // Resolver el id de la categoría
    final idCategoria = await _obtenerIdPorNombre(
      tabla: 'categoria',
      campoId: 'id_categoria',
      valor: request.categoria,
      camposNombre: const ['nombre_categoria', 'categoria', 'nombre'],
    );

    // Resolver el id del tipo de proyecto
    final idTipoProyecto = await _obtenerIdPorNombre(
      tabla: 'tipo_proyecto',
      campoId: 'id_tipo_proyecto',
      valor: request.tipoProyecto!,
      camposNombre: const ['nombre_tipo_proyecto', 'tipo_proyecto', 'nombre'],
    );

    // Resolver los ids de todos los roles seleccionados
    final Map<String, int> idsRoles = {};

    for (final nombreRol in request.roles) {
      idsRoles[nombreRol] = await _obtenerIdPorNombre(
        tabla: 'rol',
        campoId: 'id_rol',
        valor: nombreRol,
        camposNombre: const ['nombre_rol', 'rol', 'nombre'],
      );
    }

    // Resolver los ids de todas las habilidades seleccionadas
    final Map<String, int> idsHabilidades = {};

    for (final habilidad in request.habilidades) {
      idsHabilidades[habilidad] = await _obtenerIdPorNombre(
        tabla: 'habilidad',
        campoId: 'id_habilidad',
        valor: habilidad,
        camposNombre: const ['nombre_habilidad', 'habilidad', 'nombre'],
      );
    }

    // Calcular el total de integrantes sumando las cantidades por rol
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

    // Normalizar las fechas
    final fechaInicio = _inicioDelDia(request.fechaInicio);
    final fechaFinal = _finalDelDia(request.fechaCierre);

    // Fecha límite para abandonar el proyecto
    final fechaLimiteAbandono = fechaFinal.subtract(_diasAntesDeCierre);

    // Crear el modelo del proyecto
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

    // Guardar el proyecto en la tabla proyecto
    final proyectoCreado = await projectDatasource.createProject(project);

    final idProyecto = int.parse(proyectoCreado['id_proyecto'].toString());

    // Guardar cada rol del proyecto en la tabla proyecto_rol
    for (final nombreRol in request.roles) {
      final idRol = idsRoles[nombreRol]!;
      final cantidad = request.cantidadesPorRol[nombreRol]!;

      await rolesDatasource.createProjectRole(
        ProjectRoleModel(
          idProyecto: idProyecto,
          idRol: idRol,
          cantidad: cantidad,
        ),
      );
    }

    // Guardar cada habilidad del proyecto en la tabla proyecto_habilidad
    for (final nombreHabilidad in request.habilidades) {
      final idHabilidad = idsHabilidades[nombreHabilidad]!;

      await skillsDatasource.createProjectSkill(
        ProjectSkillModel(
          idProyecto: idProyecto,
          idHabilidad: idHabilidad,
        ),
      );
    }

    // Guardar la convocatoria del proyecto
    await convocatoriaDatasource.createConvocatoria(
      ConvocatoriaModel(
        idProyecto: idProyecto,
        fechaInicio: fechaInicio,
        fechaFinal: fechaFinal,
        estado: true,
        fechaLimiteDeAbandono: fechaLimiteAbandono,
      ),
    );

    // Agregar al creador como líder del proyecto
    await _agregarCreadorComoLider(
      idProyecto: idProyecto,
      idCreador: idCreador,
    );

    return {
      'proyecto': proyectoCreado,
      'id_proyecto': idProyecto,
    };
  }
}