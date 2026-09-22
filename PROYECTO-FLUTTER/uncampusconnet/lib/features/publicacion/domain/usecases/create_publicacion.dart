import '../entities/publicacion.dart';
import '../repositories/publicacion_repository.dart';

class CreatePublicacion {
  final PublicacionRepository repository;

  CreatePublicacion({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Publicacion publicacion,
  ) async {
    return await repository.createPublicacion(
      publicacion,
    );
  }
}