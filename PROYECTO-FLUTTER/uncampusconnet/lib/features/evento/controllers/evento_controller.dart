import 'package:get/get.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';

class EventoUI {
  final String nombre;
  final String tipo;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinal;

  const EventoUI({
    required this.nombre,
    required this.tipo,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFinal,
  });
}
class EventoController extends GetxController {
  /// Indicador de carga
  final cargando = false.obs;

  /// Lista de eventos del proyecto
  final eventos = <EventoUI>[].obs;

  //Cargar evtnos
  Future<void> cargarEventos(int idProyecto) async {
    cargando.value = true;

    try {
      final eventosRaw = await RobleClient.instance.read(
        'evento',
        filters: {'id_proyecto': idProyecto},
      );

      if (eventosRaw.isEmpty) {
        eventos.clear();
        return;
      }

      final lista = <EventoUI>[];

      for (final raw in eventosRaw) {
        final evento = _mapearEvento(raw);
        if (evento != null) {
          lista.add(evento);
        }
      }

      // Ordenar por fecha de inicio
      lista.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));

      eventos.assignAll(lista);
    } catch (e) {
      eventos.clear();
    } finally {
      cargando.value = false;
    }
  }

  EventoUI? _mapearEvento(Map<String, dynamic> raw) {
    try {
      final inicio = _parsearFecha(raw['fecha_inicio']);
      final final_ = _parsearFecha(raw['fecha_final']);

      if (inicio == null || final_ == null) return null;

      return EventoUI(
        nombre: raw['nombre']?.toString() ?? 'Sin nombre',
        tipo: raw['tipo_evento']?.toString() ?? 'Evento',
        descripcion: raw['descripcion']?.toString() ?? '',
        fechaInicio: inicio,
        fechaFinal: final_,
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
}