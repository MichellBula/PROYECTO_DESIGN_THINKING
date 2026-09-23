import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/home/data/event_data.dart';

class HomeController extends GetxController {
  final SesionController _sesionController = Get.find<SesionController>();

  /// Indicador de carga
  final cargando = false.obs;

  /// Nombre del usuario logueado
  final nombreUsuario = ''.obs;

  /// Lista de eventos del usuario
  final eventos = <EventData>[].obs;

  /// Si no hay eventos
  bool get sinEventos => eventos.isEmpty;

  @override
  void onInit() {
    super.onInit();
    cargarHome();
  }
  Future<void> cargarHome() async {
    cargando.value = true;

    try {
      // 1. Nombre del usuario
      nombreUsuario.value =
          _sesionController.perfilUsuario.value?.nombreUsuario ?? 'Usuario';

      // 2. ID del usuario
      final idUsuario = _sesionController.idUsuario;
      if (idUsuario == null) {
        eventos.clear();
        return;
      }

      // 3. IDs de los proyectos del usuario
      final idsProyectos = await _obtenerIdsProyectos(idUsuario);
      if (idsProyectos.isEmpty) {
        eventos.clear();
        return;
      }

      // 4. Eventos de esos proyectos
      final eventosCargados = await _cargarEventos(idsProyectos);
      eventos.assignAll(eventosCargados);
    } catch (e) {
      eventos.clear();
    } finally {
      cargando.value = false;
    }
  }

  //Obetenr ids
  Future<List<int>> _obtenerIdsProyectos(int idUsuario) async {
    final integrantes = await RobleClient.instance.read(
      'integrantes',
      filters: {'id_usuario': idUsuario},
    );

    final ids = <int>{};

    for (final item in integrantes) {
      final id = int.tryParse(item['id_proyecto'].toString());
      if (id != null) ids.add(id);
    }

    return ids.toList();
  }

  //Cargar eventos
  Future<List<EventData>> _cargarEventos(List<int> idsProyectos) async {
    final lista = <EventData>[];

    for (final idProyecto in idsProyectos) {
      final nombreProyecto = await _obtenerNombreProyecto(idProyecto);

      final eventosRaw = await RobleClient.instance.read(
        'evento',
        filters: {'id_proyecto': idProyecto},
      );

      for (final raw in eventosRaw) {
        final evento = _mapearEvento(raw, nombreProyecto);

        if (evento != null && _esHoyOFuturo(raw['fecha_inicio'])) {
          lista.add(evento);
        }
      }
    }

    return lista;
  }

  //Obtener nombre proyecto
  Future<String> _obtenerNombreProyecto(int idProyecto) async {
    final proyectos = await RobleClient.instance.read(
      'proyecto',
      filters: {'id_proyecto': idProyecto},
    );

    if (proyectos.isEmpty) return 'Proyecto';

    return proyectos.first['nombre']?.toString() ?? 'Proyecto';
  }
  EventData? _mapearEvento(
    Map<String, dynamic> raw,
    String nombreProyecto,
  ) {
    try {
      final fechaInicio = _parsearFecha(raw['fecha_inicio']);
      if (fechaInicio == null) return null;

      final tipoEvento = raw['tipo_evento']?.toString() ?? 'Evento';
      final nombre = raw['nombre']?.toString() ?? 'Sin nombre';

      return EventData(
        day: _formatearFecha(fechaInicio),
        time: _formatearHora(fechaInicio),
        title: nombre,
        project: nombreProyecto,
        tag: tipoEvento,
        icon: _iconoSegunTipo(tipoEvento),
        type: _tipoSegunTipo(tipoEvento),
      );
    } catch (e) {
      return null;
    }
  }

  //Parsear fecha
  DateTime? _parsearFecha(dynamic valor) {
    if (valor == null) return null;

    if (valor is int) {
      return DateTime.fromMillisecondsSinceEpoch(valor);
    }

    if (valor is String) {
      return DateTime.tryParse(valor);
    }

    return null;
  }

  //Filtro de fecha
  bool _esHoyOFuturo(dynamic valor) {
    final fecha = _parsearFecha(valor);
    if (fecha == null) return false;

    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final diaEvento = DateTime(fecha.year, fecha.month, fecha.day);

    return !diaEvento.isBefore(hoy);
  }

  //Fromatear fecha y hora

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();
    return '$dia/$mes/$anio';
  }

  String _formatearHora(DateTime fecha) {
    final hora = fecha.hour > 12
        ? fecha.hour - 12
        : (fecha.hour == 0 ? 12 : fecha.hour);
    final minuto = fecha.minute.toString().padLeft(2, '0');
    final periodo = fecha.hour >= 12 ? 'pm' : 'am';
    return '$hora:$minuto $periodo';
  }

  IconData _iconoSegunTipo(String tipo) {
    final t = tipo.toLowerCase();

    if (t.contains('reuni')) return Icons.person_outline;
    if (t.contains('presenta')) return Icons.slideshow_outlined;
    if (t.contains('revis')) return Icons.folder_open_outlined;
    if (t.contains('entrega') || t.contains('avance')) {
      return Icons.calendar_today_outlined;
    }

    return Icons.event;
  }

  EventType _tipoSegunTipo(String tipo) {
    final t = tipo.toLowerCase();
    if (t.contains('reuni')) return EventType.meeting;
    return EventType.task;
  }
}