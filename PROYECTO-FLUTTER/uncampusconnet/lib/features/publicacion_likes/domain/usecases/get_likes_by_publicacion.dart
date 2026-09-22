import '../repositories/publicacion_likes_repository.dart';

class GetLikesByPublicacion {
  final PublicacionLikesRepository repository;

  GetLikesByPublicacion({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idPublicacion,
  ) async {
    return await repository.getLikesByPublicacion(
      idPublicacion,
    );
  }
}