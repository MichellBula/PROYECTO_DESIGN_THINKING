import '../repositories/etapa_repository.dart';

class GetEtapasByProject {
  final EtapaRepository repository;

  GetEtapasByProject({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idProyecto,
  ) async {
    return repository.getEtapasByProject(
      idProyecto,
    );
  }
}