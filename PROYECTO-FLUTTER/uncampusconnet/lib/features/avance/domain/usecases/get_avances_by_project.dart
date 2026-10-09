import '../repositories/avance_repository.dart';

class GetAvancesByProject {
  final AvanceRepository repository;

  GetAvancesByProject({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idProyecto,
  ) async {
    return repository.getAvancesByProject(
      idProyecto,
    );
  }
}