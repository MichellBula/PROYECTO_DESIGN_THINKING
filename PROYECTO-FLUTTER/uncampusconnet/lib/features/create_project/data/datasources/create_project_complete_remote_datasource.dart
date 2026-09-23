import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../domain/entities/create_project_request.dart';

class CreateProjectCompleteRemoteDatasource {
  final RobleApiDataBase roble;

  CreateProjectCompleteRemoteDatasource({RobleApiDataBase? roble})
    : roble = roble ?? RobleClient.instance;

  static const int _maxIntentos = 5;

  // La prueba de convocatoria que ya hicimos utilizaba
  // dos días antes del cierre como fecha límite de abandono.
  static const Duration _diasAntesDeCierre = Duration(days: 2);

  // ==========================================================
  // USUARIO AUTENTICADO
  // ==========================================================

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

  // ==========================================================
  // BUSCAR ID POR NOMBRE
  // ==========================================================

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

  // ==========================================================
  // IDS
  // ==========================================================

  Future<int> _obtenerSiguienteId({
    required String tabla,
    required String campoId,
  }) async {
    final registros = await roble.read(tabla);

    int mayorId = 0;

    for (final registro in registros) {
      final id = int.tryParse(registro[campoId].toString());

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idExiste({
    required String tabla,
    required String campoId,
    required int id,
  }) async {
    final registros = await roble.read(tabla, filters: {campoId: id});

    return registros.isNotEmpty;
  }

  // ==========================================================
  // NORMALIZAR FECHA
  // ==========================================================

  DateTime _inicioDelDia(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  DateTime _finalDelDia(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);
  }

  // ==========================================================
  // CREAR
  // ==========================================================

  Future<Map<String, dynamic>> crearProyectoCompleto(
    CreateProjectRequest request,
  ) async {
    // ========================================================
    // VALIDACIONES
    // ========================================================

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

    // ========================================================
    // USUARIO AUTENTICADO
    // ========================================================

    final idCreador = await _obtenerIdUsuarioAutenticado();

    // ========================================================
    // RESOLVER IDS DE CATÁLOGOS
    // ========================================================

    final idCategoria = await _obtenerIdPorNombre(
      tabla: 'categoria',
      campoId: 'id_categoria',
      valor: request.categoria,
      camposNombre: const ['nombre_categoria', 'categoria', 'nombre'],
    );

    final idTipoProyecto = await _obtenerIdPorNombre(
      tabla: 'tipo_proyecto',
      campoId: 'id_tipo_proyecto',
      valor: request.tipoProyecto!,
      camposNombre: const ['nombre_tipo_proyecto', 'tipo_proyecto', 'nombre'],
    );

    final Map<String, int> idsRoles = {};

    for (final nombreRol in request.roles) {
      idsRoles[nombreRol] = await _obtenerIdPorNombre(
        tabla: 'rol',
        campoId: 'id_rol',
        valor: nombreRol,
        camposNombre: const ['nombre_rol', 'rol', 'nombre'],
      );
    }

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

    for (final cantidad in request.cantidadesPorRol.values) {
      if (cantidad <= 0) {
        throw Exception('Todos los roles deben tener al menos 1 integrante.');
      }

      totalIntegrantes += cantidad;
    }

    // ========================================================
    // FECHAS DE CONVOCATORIA
    // ========================================================

    final fechaInicio = _inicioDelDia(request.fechaInicio);

    final fechaFinal = _finalDelDia(request.fechaCierre);

    final fechaLimiteAbandono = fechaFinal.subtract(_diasAntesDeCierre);

    // ========================================================
    // CREAR PROYECTO
    // ========================================================

    Map<String, dynamic>? proyectoCreado;

    for (int intento = 1; intento <= _maxIntentos; intento++) {
      final idProyecto = await _obtenerSiguienteId(
        tabla: 'proyecto',
        campoId: 'id_proyecto',
      );

      try {
        final resultado = await roble.create('proyecto', {
          'id_proyecto': idProyecto,
          'nombre': request.nombreProyecto.trim(),
          'descripcion': request.descripcion.trim(),
          'id_creador': idCreador,
          'id_categoria': idCategoria,
          'id_tipo_proyecto': idTipoProyecto,
          'objetivo': request.objetivo.trim(),
          'requisitos': request.requisitos.trim(),
          'num_integrantes': totalIntegrantes,
          'docente_asesor': request.deseaDocente,
          'estado': 'activo',
        });

        proyectoCreado = Map<String, dynamic>.from(resultado);

        break;
      } catch (e) {
        final existe = await _idExiste(
          tabla: 'proyecto',
          campoId: 'id_proyecto',
          id: idProyecto,
        );

        if (!existe || intento == _maxIntentos) {
          rethrow;
        }
      }
    }

    if (proyectoCreado == null) {
      throw Exception('No fue posible crear el proyecto.');
    }

    final idProyecto = int.parse(proyectoCreado!['id_proyecto'].toString());

    // ========================================================
    // CREAR PROYECTO_ROLES
    // ========================================================

    for (final nombreRol in request.roles) {
      final idRol = idsRoles[nombreRol]!;

      final cantidad = request.cantidadesPorRol[nombreRol] ?? 0;

      bool creado = false;

      for (int intento = 1; intento <= _maxIntentos; intento++) {
        final idProyectoRol = await _obtenerSiguienteId(
          tabla: 'proyecto_Roles',
          campoId: 'id_proyecto_rol',
        );

        try {
          await roble.create('proyecto_Roles', {
            'id_proyecto_rol': idProyectoRol,
            'id_proyecto': idProyecto,
            'id_rol': idRol,
            'cantidad': cantidad,
          });

          creado = true;
          break;
        } catch (e) {
          final existe = await _idExiste(
            tabla: 'proyecto_Roles',
            campoId: 'id_proyecto_rol',
            id: idProyectoRol,
          );

          if (!existe || intento == _maxIntentos) {
            rethrow;
          }
        }
      }

      if (!creado) {
        throw Exception(
          'No fue posible crear la relación con el rol "$nombreRol".',
        );
      }
    }

    // ========================================================
    // CREAR PROYECTO_HABILIDADES
    // ========================================================

    for (final nombreHabilidad in request.habilidades) {
      final idHabilidad = idsHabilidades[nombreHabilidad]!;

      bool creado = false;

      for (int intento = 1; intento <= _maxIntentos; intento++) {
        final idProyectoHabilidad = await _obtenerSiguienteId(
          tabla: 'proyecto_habilidades',
          campoId: 'id_proyecto_habilidad',
        );

        try {
          await roble.create('proyecto_habilidades', {
            'id_proyecto_habilidad': idProyectoHabilidad,
            'id_proyecto': idProyecto,
            'id_habilidad': idHabilidad,
          });

          creado = true;
          break;
        } catch (e) {
          final existe = await _idExiste(
            tabla: 'proyecto_habilidades',
            campoId: 'id_proyecto_habilidad',
            id: idProyectoHabilidad,
          );

          if (!existe || intento == _maxIntentos) {
            rethrow;
          }
        }
      }

      if (!creado) {
        throw Exception(
          'No fue posible crear la relación con la habilidad "$nombreHabilidad".',
        );
      }
    }

    // ========================================================
    // CREAR CONVOCATORIA
    // ========================================================

    await roble.create('convocatoria', {
      'id_proyecto': idProyecto,
      'fecha_inicio': fechaInicio.toUtc().toIso8601String(),
      'fecha_final': fechaFinal.toUtc().toIso8601String(),
      'estado': true,
      'fecha_limite_de_abandono': fechaLimiteAbandono.toUtc().toIso8601String(),
    });

    // ========================================================
    // RESULTADO
    // ========================================================

    return {'proyecto': proyectoCreado, 'id_proyecto': idProyecto};
  }
}
