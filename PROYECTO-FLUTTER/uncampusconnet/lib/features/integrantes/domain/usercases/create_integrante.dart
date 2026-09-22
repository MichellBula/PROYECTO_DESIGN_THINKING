import '../entities/integrante.dart';
import '../repositories/integrante_repository.dart';

class CreateIntegrante {
  final IntegranteRepository repository;

  CreateIntegrante({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Integrante integrante,
  ) async {
    return await repository.createIntegrante(
      integrante,
    );
  }
}