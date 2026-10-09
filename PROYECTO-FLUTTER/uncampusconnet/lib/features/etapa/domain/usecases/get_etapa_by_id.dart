import '../repositories/etapa_repository.dart';

class GetEtapaById {
  final EtapaRepository repository;

  GetEtapaById({
    required this.repository,
  });

  Future<Map<String, dynamic>?> call(
    int idEtapa,
  ) async {
    return repository.getEtapaById(
      idEtapa,
    );
  }
}