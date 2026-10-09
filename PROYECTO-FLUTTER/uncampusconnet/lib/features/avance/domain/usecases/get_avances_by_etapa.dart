import '../repositories/avance_repository.dart';

class GetAvancesByEtapa {
  final AvanceRepository repository;

  GetAvancesByEtapa({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idEtapa,
  ) async {
    return repository.getAvancesByEtapa(
      idEtapa,
    );
  }
}