import '../repositories/avance_repository.dart';

class GetAvanceById {
  final AvanceRepository repository;

  GetAvanceById({
    required this.repository,
  });

  Future<Map<String, dynamic>?> call(
    int idAvance,
  ) async {
    return repository.getAvanceById(
      idAvance,
    );
  }
}