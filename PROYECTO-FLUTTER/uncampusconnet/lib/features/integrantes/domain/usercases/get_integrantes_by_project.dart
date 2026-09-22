import '../repositories/integrante_repository.dart';

class GetIntegrantesByProject {
  final IntegranteRepository repository;

  GetIntegrantesByProject({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idProyecto,
  ) async {
    return await repository.getIntegrantesByProject(
      idProyecto,
    );
  }
}