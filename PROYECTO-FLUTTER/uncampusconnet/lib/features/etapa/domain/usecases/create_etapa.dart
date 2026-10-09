import '../entities/etapa.dart';
import '../repositories/etapa_repository.dart';

class CreateEtapa {
  final EtapaRepository repository;

  CreateEtapa({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Etapa etapa,
  ) async {
    return repository.createEtapa(
      etapa,
    );
  }
}