import '../entities/evento.dart';

abstract class EventoRepository {
  Future<Map<String, dynamic>> createEvento(
    Evento evento,
  );

  Future<List<Map<String, dynamic>>> getEventosByProject(
    int idProyecto,
  );

  Future<Map<String, dynamic>?> getEventoById(
    int idEvento,
  );
}