import '../repositories/publicacion_repository.dart';

class GetPublicacionById {
  final PublicacionRepository repository;

  GetPublicacionById({
    required this.repository,
  });

  Future<Map<String, dynamic>?> call(
    int idPublicacion,
  ) async {
    return await repository.getPublicacionById(
      idPublicacion,
    );
  }
}