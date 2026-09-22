import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/evento_model.dart';

class EventoRemoteDatasource {
  final RobleApiDataBase roble;

  EventoRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  static const int _maxIntentosCrearEvento = 5;

  Future<int> _obtenerSiguienteId() async {
    final eventos = await roble.read(
      'evento',
    );

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

  Future<bool> _idExiste(
    int idEvento,
  ) async {
    final eventos = await roble.read(
      'evento',
      filters: {
        'id_evento': idEvento,
      },
    );

    return eventos.isNotEmpty;
  }

  Future<int> _obtenerIdUsuarioAutenticado() async {
    final user = await roble.currentUser();

    final userId =
        user['userId']?.toString();

    if (userId == null || userId.isEmpty) {
      throw Exception(
        'No fue posible obtener el usuario autenticado.',
      );
    }

    final usuarios = await roble.read(
      'usuario',
      filters: {
        'id_autenticador': userId,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'No existe un perfil de usuario asociado a la cuenta autenticada.',
      );
    }

    final idUsuario =
        int.tryParse(
      usuarios.first['id_usuario'].toString(),
    );

    if (idUsuario == null) {
      throw Exception(
        'El perfil de usuario no tiene un id_usuario válido.',
      );
    }

    return idUsuario;
  }

  Future<int> _obtenerIdCreadorDelProyecto(
    int idProyecto,
  ) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'No existe el proyecto con id $idProyecto.',
      );
    }

    final idCreador =
        int.tryParse(
      proyectos.first['id_creador'].toString(),
    );

    if (idCreador == null) {
      throw Exception(
        'El proyecto no tiene un id_creador válido.',
      );
    }

    return idCreador;
  }

  Future<Map<String, dynamic>> createEvento(
    EventoModel evento,
  ) async {
    if (evento.nombre.trim().isEmpty) {
      throw Exception(
        'El nombre del evento no puede estar vacío.',
      );
    }

    if (evento.tipoEvento.trim().isEmpty) {
      throw Exception(
        'El tipo de evento no puede estar vacío.',
      );
    }

    if (evento.descripcion.trim().isEmpty) {
      throw Exception(
        'La descripción del evento no puede estar vacía.',
      );
    }

    if (evento.fechaFinal.isBefore(
      evento.fechaInicio,
    )) {
      throw Exception(
        'La fecha final no puede ser anterior a la fecha de inicio.',
      );
    }

    // -------------------------------------------------------
    // Verificar que el proyecto exista
    // -------------------------------------------------------

    final idCreador =
        await _obtenerIdCreadorDelProyecto(
      evento.idProyecto,
    );

    // -------------------------------------------------------
    // Verificar que el usuario autenticado
    // sea el creador del proyecto
    // -------------------------------------------------------

    final idUsuarioAutenticado =
        await _obtenerIdUsuarioAutenticado();

    if (idUsuarioAutenticado != idCreador) {
      throw Exception(
        'Solo el creador del proyecto puede crear eventos.',
      );
    }

    // -------------------------------------------------------
    // Crear evento
    // -------------------------------------------------------

    for (
      int intento = 1;
      intento <= _maxIntentosCrearEvento;
      intento++
    ) {
      final idEvento =
          await _obtenerSiguienteId();

      try {
        final resultado = await roble.create(
          'evento',
          evento.toMap(
            idEvento: idEvento,
          ),
        );

        return Map<String, dynamic>.from(
          resultado,
        );
      } catch (e) {
        final idFueOcupado =
            await _idExiste(idEvento);

        if (
          !idFueOcupado ||
          intento == _maxIntentosCrearEvento
        ) {
          rethrow;
        }
      }
    }

    throw Exception(
      'No fue posible crear el evento.',
    );
  }

  Future<List<Map<String, dynamic>>> getEventosByProject(
    int idProyecto,
  ) async {
    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'No existe el proyecto con id $idProyecto.',
      );
    }

    final eventos = await roble.read(
      'evento',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    return eventos
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<Map<String, dynamic>?> getEventoById(
    int idEvento,
  ) async {
    final eventos = await roble.read(
      'evento',
      filters: {
        'id_evento': idEvento,
      },
    );

    if (eventos.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      eventos.first,
    );
  }
}