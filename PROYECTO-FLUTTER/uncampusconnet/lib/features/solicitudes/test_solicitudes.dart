import 'package:uncampusconnet/core/database/roble_client.dart';

import 'package:uncampusconnet/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:uncampusconnet/features/solicitudes/data/repositories/solicitud_repository_impl.dart';
import 'package:uncampusconnet/features/solicitudes/domain/entities/solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/create_solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/get_mis_solicitudes.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/get_solicitudes_pendientes.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE SOLICITUDES Y COLUMNA COMENTARIO');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    // =====================================================
    // CONFIGURACION DE LA PRUEBA
    // =====================================================

    const idProyecto = 16;
    const idRol = 5;

    const comentarioPrueba =
        'Me interesa participar en este proyecto porque '
        'puedo aportar mis conocimientos y aprender '
        'junto al equipo.';

    // =====================================================
    // LOGIN
    // =====================================================

    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    // =====================================================
    // DEPENDENCIAS
    // =====================================================

    final datasource = SolicitudRemoteDatasource(
      roble: roble,
    );

    final repository = SolicitudRepositoryImpl(
      datasource: datasource,
    );

    final createSolicitud = CreateSolicitud(
      repository: repository,
    );

    final getMisSolicitudes = GetMisSolicitudes(
      repository: repository,
    );

    final getSolicitudesPendientes =
        GetSolicitudesPendientes(
      repository: repository,
    );

    // =====================================================
    // OBTENER USUARIO AUTENTICADO
    // =====================================================

    print('\n--- OBTENIENDO USUARIO AUTENTICADO ---');

    final idUsuarioPostulante =
        await datasource.getIdUsuarioAutenticado();

    print(
      'id_usuario autenticado: $idUsuarioPostulante',
    );

    // =====================================================
    // COMPROBAR PROYECTO
    // =====================================================

    print('\n--- COMPROBANDO PROYECTO ---');

    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'No existe el proyecto $idProyecto.',
      );
    }

    final proyecto = Map<String, dynamic>.from(
      proyectos.first,
    );

    final idCreador = int.tryParse(
      proyecto['id_creador'].toString(),
    );

    if (idCreador == null) {
      throw Exception(
        'El proyecto no tiene un id_creador válido.',
      );
    }

    print(
      'Proyecto encontrado: ${proyecto['nombre']}',
    );

    print(
      'id_proyecto: $idProyecto',
    );

    print(
      'id_creador: $idCreador',
    );

    // =====================================================
    // COMPROBAR QUE NO SEA EL CREADOR
    // =====================================================

    print('\n--- VALIDANDO POSTULANTE ---');

    if (idUsuarioPostulante == idCreador) {
      throw Exception(
        'La cuenta autenticada es el creador del proyecto. '
        'Utiliza una cuenta diferente para postularte.',
      );
    }

    print(
      'El usuario puede postularse a este proyecto.',
    );

    // =====================================================
    // BUSCAR EL ROL DENTRO DEL PROYECTO
    // =====================================================

    print('\n--- COMPROBANDO ROL ---');

    final roles = await roble.read(
      'proyecto_roles',
      filters: {
        'id_proyecto': idProyecto,
        'id_rol': idRol,
      },
    );

    if (roles.isEmpty) {
      throw Exception(
        'El proyecto $idProyecto no tiene asociado '
        'el rol id_rol=$idRol. '
        'Verifica la tabla proyecto_roles.',
      );
    }

    final proyectoRol = Map<String, dynamic>.from(
      roles.first,
    );

    final idProyectoRol = int.tryParse(
      proyectoRol['id_proyecto_rol'].toString(),
    );

    if (idProyectoRol == null) {
      throw Exception(
        'No se pudo obtener un id_proyecto_rol válido.',
      );
    }

    print('Rol encontrado.');
    print('id_rol: $idRol');
    print('id_proyecto_rol: $idProyectoRol');

    // =====================================================
    // EVITAR DUPLICAR LA SOLICITUD DE PRUEBA
    // =====================================================

    print('\n--- COMPROBANDO SOLICITUD EXISTENTE ---');

    final solicitudesExistentes = await roble.read(
      'solicitudes',
      filters: {
        'id_usuario': idUsuarioPostulante,
        'id_proyecto': idProyecto,
      },
    );

    if (solicitudesExistentes.isNotEmpty) {
      final solicitudExistente =
          Map<String, dynamic>.from(
        solicitudesExistentes.first,
      );

      print(
        'Ya existe una solicitud de este usuario '
        'para el proyecto $idProyecto.',
      );

      print(
        'id_solicitud: '
        '${solicitudExistente['id_solicitud']}',
      );

      print(
        'estado: ${solicitudExistente['estado']}',
      );

      print(
        'comentario guardado: '
        '${solicitudExistente['comentario']}',
      );

      throw Exception(
        'No se creará otra solicitud porque la aplicación '
        'solo permite una por usuario y proyecto. '
        'Utiliza un usuario sin solicitud previa para probar '
        'la creación de un nuevo registro.',
      );
    }

    print(
      'No existe una solicitud previa. Se puede continuar.',
    );

    // =====================================================
    // CREAR SOLICITUD CON COMENTARIO
    // =====================================================

    print('\n--- CREANDO SOLICITUD ---');

    final solicitud = Solicitud(
      idProyecto: idProyecto,
      idUsuario: idUsuarioPostulante,
      estado: 'pendiente',
      fechaEnviada: DateTime.now(),
      fechaRespuesta: null,
      idProyectoRol: idProyectoRol,
      comentario: comentarioPrueba,
    );

    final resultadoCrear = await createSolicitud(
      solicitud,
    );

    print('Solicitud creada correctamente.');

    print('Resultado: $resultadoCrear');

    final idSolicitud = int.parse(
      resultadoCrear['id_solicitud'].toString(),
    );

    print(
      'id_solicitud generado: $idSolicitud',
    );

    // =====================================================
    // VERIFICAR COMENTARIO DEVUELTO POR ROBLE
    // =====================================================

    print('\n--- VERIFICANDO COMENTARIO DEVUELTO ---');

    final comentarioDevuelto =
        resultadoCrear['comentario']?.toString();

    print(
      'Comentario enviado: $comentarioPrueba',
    );

    print(
      'Comentario devuelto: $comentarioDevuelto',
    );

    if (comentarioDevuelto != comentarioPrueba) {
      throw Exception(
        'El comentario devuelto por Roble '
        'no coincide con el enviado.',
      );
    }

    print(
      'Comentario devuelto correctamente.',
    );

    // =====================================================
    // LEER SOLICITUD GUARDADA EN ROBLE
    // =====================================================

    print('\n--- LEYENDO SOLICITUD GUARDADA ---');

    final solicitudLeida =
        await repository.getSolicitudById(
      idSolicitud,
    );

    if (solicitudLeida == null) {
      throw Exception(
        'La solicitud fue creada pero no se pudo recuperar.',
      );
    }

    print('Solicitud encontrada.');

    print(
      'id_solicitud: ${solicitudLeida['id_solicitud']}',
    );

    print(
      'id_proyecto: ${solicitudLeida['id_proyecto']}',
    );

    print(
      'id_usuario: ${solicitudLeida['id_usuario']}',
    );

    print(
      'id_proyecto_rol: '
      '${solicitudLeida['id_proyecto_rol']}',
    );

    print(
      'estado: ${solicitudLeida['estado']}',
    );

    print(
      'comentario: ${solicitudLeida['comentario']}',
    );

    print(
      'fecha_enviada: ${solicitudLeida['fecha_enviada']}',
    );

    // Verificar que el dato quedó persistido.
    final comentarioGuardado =
        solicitudLeida['comentario']?.toString();

    if (comentarioGuardado != comentarioPrueba) {
      throw Exception(
        'El comentario no quedó guardado correctamente '
        'en la tabla solicitudes.',
      );
    }

    print(
      'La columna comentario quedó guardada correctamente.',
    );

    // =====================================================
    // CONSULTAR MIS SOLICITUDES
    // =====================================================

    print('\n--- MIS SOLICITUDES ---');

    final misSolicitudes = await getMisSolicitudes(
      idUsuarioPostulante,
    );

    print(
      'Cantidad de solicitudes del usuario '
      '$idUsuarioPostulante: ${misSolicitudes.length}',
    );

    for (final item in misSolicitudes) {
      print(
        'id=${item['id_solicitud']} '
        '→ proyecto=${item['id_proyecto']} '
        '→ proyectoRol=${item['id_proyecto_rol']} '
        '→ estado=${item['estado']} '
        '→ comentario=${item['comentario']}',
      );
    }

    // =====================================================
    // CONSULTAR SOLICITUDES PENDIENTES DEL CREADOR
    // =====================================================

    print(
      '\n--- SOLICITUDES PENDIENTES DEL CREADOR ---',
    );

    final pendientes = await getSolicitudesPendientes(
      idCreador,
    );

    final pendientesProyecto = pendientes.where(
      (item) =>
          int.tryParse(
            item['id_proyecto'].toString(),
          ) ==
          idProyecto,
    ).toList();

    print(
      'Solicitudes pendientes del proyecto '
      '$idProyecto: ${pendientesProyecto.length}',
    );

    for (final item in pendientesProyecto) {
      print(
        'id=${item['id_solicitud']} '
        '→ usuario=${item['id_usuario']} '
        '→ estado=${item['estado']} '
        '→ comentario=${item['comentario']}',
      );
    }

    if (!pendientesProyecto.any(
      (item) =>
          int.tryParse(
            item['id_solicitud'].toString(),
          ) ==
          idSolicitud,
    )) {
      throw Exception(
        'La solicitud creada no apareció en la lista '
        'de pendientes del creador.',
      );
    }

    print(
      'La solicitud aparece correctamente en las pendientes del creador.',
    );

    // =====================================================
    // LOGOUT
    // =====================================================

    print('\n--- LOGOUT ---');

    await roble.logout();

    print('Logout exitoso.');

    print('\n========================================');
    print('✅ TEST FINALIZADO CORRECTAMENTE');
    print('========================================');
  } catch (e, stackTrace) {
    print('\n========================================');
    print('ERROR EN EL TEST');
    print('========================================');

    print(e);

    print('\nStackTrace:');
    print(stackTrace);

    try {
      await roble.logout();
    } catch (_) {}
  }
}