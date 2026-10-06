import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';

import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';

import 'package:uncampusconnet/features/home/data/event_data.dart';
import 'package:uncampusconnet/features/home/data/post_data.dart';

import 'package:uncampusconnet/features/publicacion/data/datasources/publicacion_remote_datasource.dart';
import 'package:uncampusconnet/features/publicacion/data/repositories/publicacion_repository_impl.dart';
import 'package:uncampusconnet/features/publicacion/domain/usecases/get_todas_las_publicaciones.dart';

class HomeController extends GetxController {
  final SesionController _sesionController =
      Get.find<SesionController>();

  // =========================================================
  // PUBLICACIONES
  // =========================================================

  final publicaciones = <PostData>[].obs;

  final cargandoPublicaciones = false.obs;

  bool get sinPublicaciones => publicaciones.isEmpty;

  late final GetTodasLasPublicaciones
      _getTodasLasPublicaciones;

  // =========================================================
  // EVENTOS
  // =========================================================

  final cargando = false.obs;

  final nombreUsuario = ''.obs;

  final eventos = <EventData>[].obs;

  bool get sinEventos => eventos.isEmpty;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    final datasource =
        PublicacionRemoteDatasource();

    final repository =
        PublicacionRepositoryImpl(
      datasource: datasource,
    );

    _getTodasLasPublicaciones =
        GetTodasLasPublicaciones(
      repository: repository,
    );

    cargarHome();
    cargarPublicaciones();
  }

  // =========================================================
  // CARGAR HOME
  // =========================================================

  Future<void> cargarHome() async {
    cargando.value = true;

    try {
      // -----------------------------------------------------
      // 1. Nombre del usuario
      // -----------------------------------------------------

      nombreUsuario.value =
          _sesionController
                  .perfilUsuario
                  .value
                  ?.nombreUsuario ??
              'Usuario';

      // -----------------------------------------------------
      // 2. ID del usuario
      // -----------------------------------------------------

      final idUsuario =
          _sesionController.idUsuario;

      if (idUsuario == null) {
        eventos.clear();
        return;
      }

      // -----------------------------------------------------
      // 3. Obtener proyectos del usuario
      // -----------------------------------------------------

      final idsProyectos =
          await _obtenerIdsProyectos(
        idUsuario,
      );

      if (idsProyectos.isEmpty) {
        eventos.clear();
        return;
      }

      // -----------------------------------------------------
      // 4. Obtener eventos
      // -----------------------------------------------------

      final eventosCargados =
          await _cargarEventos(
        idsProyectos,
      );

      eventos.assignAll(
        eventosCargados,
      );
    } catch (e) {
      eventos.clear();
    } finally {
      cargando.value = false;
    }
  }

  // =========================================================
  // CARGAR TODAS LAS PUBLICACIONES
  // =========================================================

  Future<void> cargarPublicaciones() async {
    cargandoPublicaciones.value = true;

    try {
      final publicacionesRaw =
          await _getTodasLasPublicaciones();

      final lista = <PostData>[];

      for (final raw in publicacionesRaw) {
        final post =
            await _mapearPublicacion(raw);

        if (post != null) {
          lista.add(post);
        }
      }

      publicaciones.assignAll(lista);
    } catch (e) {
      debugPrint(
        'Error cargando publicaciones: $e',
      );

      publicaciones.clear();
    } finally {
      cargandoPublicaciones.value = false;
    }
  }

  // =========================================================
  // MAPEAR PUBLICACIÓN
  // =========================================================

  Future<PostData?> _mapearPublicacion(
    Map<String, dynamic> raw,
  ) async {
    try {
      final idPublicacion =
          int.tryParse(
        raw['id_publicacion'].toString(),
      );

      final idProyecto =
          int.tryParse(
        raw['id_proyecto'].toString(),
      );

      if (idPublicacion == null ||
          idProyecto == null) {
        return null;
      }

      final titulo =
          raw['titulo']?.toString() ??
              'Sin título';

      final contenido =
          raw['contenido']?.toString() ??
              '';

      final fecha =
          _parsearFecha(
        raw['fecha_publicacion'],
      );

      if (fecha == null) {
        return null;
      }

      // -----------------------------------------------------
      // Obtener nombre del proyecto
      // -----------------------------------------------------

      final nombreProyecto =
          await _obtenerNombreProyecto(
        idProyecto,
      );

      return PostData(
        idPublicacion: idPublicacion,
        idProyecto: idProyecto,
        nombreProyecto: nombreProyecto,
        titulo: titulo,
        contenido: contenido,
        fechaPublicacion: fecha,
        // Por ahora estos dos valores vienen en 0.
        // Luego los conectaremos con sus tablas.
        likes: 0,
        comentarios: 0,
      );
    } catch (e) {
      debugPrint(
        'Error mapeando publicación: $e',
      );

      return null;
    }
  }

  // =========================================================
  // OBTENER NOMBRE DEL PROYECTO
  // =========================================================

  Future<String> _obtenerNombreProyecto(
    int idProyecto,
  ) async {
    final proyectos =
        await RobleClient.instance.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      return 'Proyecto';
    }

    return proyectos.first['nombre']
            ?.toString() ??
        'Proyecto';
  }

  // =========================================================
  // OBTENER PROYECTOS DEL USUARIO
  // =========================================================

  Future<List<int>> _obtenerIdsProyectos(
    int idUsuario,
  ) async {
    final integrantes =
        await RobleClient.instance.read(
      'integrantes',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    final ids = <int>{};

    for (final item in integrantes) {
      final id =
          int.tryParse(
        item['id_proyecto'].toString(),
      );

      if (id != null) {
        ids.add(id);
      }
    }

    return ids.toList();
  }

  // =========================================================
  // CARGAR EVENTOS
  // =========================================================

  Future<List<EventData>> _cargarEventos(
    List<int> idsProyectos,
  ) async {
    final lista = <EventData>[];

    for (final idProyecto
        in idsProyectos) {
      final nombreProyecto =
          await _obtenerNombreProyecto(
        idProyecto,
      );

      final eventosRaw =
          await RobleClient.instance.read(
        'evento',
        filters: {
          'id_proyecto': idProyecto,
        },
      );

      for (final raw in eventosRaw) {
        final evento =
            _mapearEvento(
          raw,
          nombreProyecto,
        );

        if (evento != null &&
            _esHoyOFuturo(
              raw['fecha_inicio'],
            )) {
          lista.add(evento);
        }
      }
    }

    return lista;
  }

  // =========================================================
  // MAPEAR EVENTO
  // =========================================================

  EventData? _mapearEvento(
    Map<String, dynamic> raw,
    String nombreProyecto,
  ) {
    try {
      final fechaInicio =
          _parsearFecha(
        raw['fecha_inicio'],
      );

      if (fechaInicio == null) {
        return null;
      }

      final tipoEvento =
          raw['tipo_evento']?.toString() ??
              'Evento';

      final nombre =
          raw['nombre']?.toString() ??
              'Sin nombre';

      return EventData(
        day: _formatearFecha(
          fechaInicio,
        ),
        time: _formatearHora(
          fechaInicio,
        ),
        title: nombre,
        project: nombreProyecto,
        tag: tipoEvento,
        icon: _iconoSegunTipo(
          tipoEvento,
        ),
        type: _tipoSegunTipo(
          tipoEvento,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // =========================================================
  // PARSEAR FECHA
  // =========================================================

  DateTime? _parsearFecha(
    dynamic valor,
  ) {
    if (valor == null) {
      return null;
    }

    if (valor is int) {
      return DateTime
          .fromMillisecondsSinceEpoch(
        valor,
      );
    }

    if (valor is String) {
      return DateTime.tryParse(
        valor,
      );
    }

    return null;
  }

  // =========================================================
  // FILTRO DE FECHA
  // =========================================================

  bool _esHoyOFuturo(
    dynamic valor,
  ) {
    final fecha =
        _parsearFecha(valor);

    if (fecha == null) {
      return false;
    }

    final ahora = DateTime.now();

    final hoy = DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
    );

    final diaEvento = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
    );

    return !diaEvento.isBefore(hoy);
  }

  // =========================================================
  // FORMATEAR FECHA
  // =========================================================

  String _formatearFecha(
    DateTime fecha,
  ) {
    final dia =
        fecha.day.toString().padLeft(
              2,
              '0',
            );

    final mes =
        fecha.month.toString().padLeft(
              2,
              '0',
            );

    final anio =
        fecha.year.toString();

    return '$dia/$mes/$anio';
  }

  // =========================================================
  // FORMATEAR HORA
  // =========================================================

  String _formatearHora(
    DateTime fecha,
  ) {
    final hora = fecha.hour > 12
        ? fecha.hour - 12
        : (fecha.hour == 0
            ? 12
            : fecha.hour);

    final minuto =
        fecha.minute
            .toString()
            .padLeft(2, '0');

    final periodo =
        fecha.hour >= 12
            ? 'pm'
            : 'am';

    return '$hora:$minuto $periodo';
  }

  // =========================================================
  // TIEMPO RELATIVO DE PUBLICACIÓN
  // =========================================================

  String tiempoDesdePublicacion(
    DateTime fecha,
  ) {
    final ahora = DateTime.now();

    final diferencia =
        ahora.difference(fecha);

    if (diferencia.isNegative) {
      return 'Ahora';
    }

    if (diferencia.inMinutes < 1) {
      return 'Ahora';
    }

    if (diferencia.inMinutes < 60) {
      return '${diferencia.inMinutes} min';
    }

    if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours}h';
    }

    if (diferencia.inDays == 1) {
      return 'Ayer';
    }

    if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays} días';
    }

    final dia =
        fecha.day.toString().padLeft(
              2,
              '0',
            );

    final mes =
        fecha.month.toString().padLeft(
              2,
              '0',
            );

    return '$dia/$mes/${fecha.year}';
  }

  // =========================================================
  // ICONOS DE EVENTOS
  // =========================================================

  IconData _iconoSegunTipo(
    String tipo,
  ) {
    final t =
        tipo.toLowerCase();

    if (t.contains('reuni')) {
      return Icons.person_outline;
    }

    if (t.contains('presenta')) {
      return Icons.slideshow_outlined;
    }

    if (t.contains('revis')) {
      return Icons.folder_open_outlined;
    }

    if (t.contains('entrega') ||
        t.contains('avance')) {
      return Icons.calendar_today_outlined;
    }

    return Icons.event;
  }

  EventType _tipoSegunTipo(
    String tipo,
  ) {
    final t =
        tipo.toLowerCase();

    if (t.contains('reuni')) {
      return EventType.meeting;
    }

    return EventType.task;
  }
}