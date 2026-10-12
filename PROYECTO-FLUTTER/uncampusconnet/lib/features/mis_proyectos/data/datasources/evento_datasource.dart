import 'package:roble/roble.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/evento_data.dart';

class EventoDatasource {
  final RobleApiDataBase roble;

  EventoDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearEvento = 5;

  Future<List<EventoData>> getEventosByProject(
    int idProyecto,
  ) async {
    final eventos = await roble.read(
      'evento',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    return eventos
        .map(
          (item) => EventoData.fromMap(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<int> _obtenerSiguienteId() async {
    final eventos = await roble.read('evento');

    int mayorId = 0;

    for (final evento in eventos) {
      final id = int.tryParse(
        evento['id_evento'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idExiste(int idEvento) async {
    final eventos = await roble.read(
      'evento',
      filters: {
        'id_evento': idEvento,
      },
    );

    return eventos.isNotEmpty;
  }

  Future<EventoData> createEvento(
    EventoData evento,
  ) async {
    for (
      int intento = 1;
      intento <= _maxIntentosCrearEvento;
      intento++
    ) {
      final idEvento = await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'evento',
          {
            'id_evento': idEvento,
            'id_proyecto': evento.idProyecto,
            'nombre': evento.nombre,
            'tipo_evento': evento.tipoEvento,
            'descripcion': evento.descripcion,
            'fecha_inicio': evento.fechaInicio
                .toIso8601String()
                .split('.')
                .first,
            'fecha_final': evento.fechaFinal
                .toIso8601String()
                .split('.')
                .first,
          },
        );

        return EventoData.fromMap(
          Map<String, dynamic>.from(resultado),
        );
      } catch (e) {
        final idFueOcupado = await _idExiste(idEvento);

        if (!idFueOcupado || intento == _maxIntentosCrearEvento) {
          rethrow;
        }
      }
    }

    throw Exception('No fue posible crear el evento.');
  }
}