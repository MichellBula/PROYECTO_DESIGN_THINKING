import '../repositories/evento_repository.dart';

class GetEventosByProject {
  final EventoRepository repository;

  GetEventosByProject({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idProyecto,
  ) async {
    return await repository.getEventosByProject(
      idProyecto,
    );
  }
}