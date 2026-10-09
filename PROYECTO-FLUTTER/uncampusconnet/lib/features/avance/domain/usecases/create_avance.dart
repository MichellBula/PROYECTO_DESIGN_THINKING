import '../entities/avance.dart';
import '../repositories/avance_repository.dart';

class CreateAvance {
  final AvanceRepository repository;

  CreateAvance({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Avance avance,
  ) async {
    return repository.createAvance(
      avance,
    );
  }
}