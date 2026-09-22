import '../entities/publicacion_like.dart';
import '../repositories/publicacion_likes_repository.dart';

class CreatePublicacionLike {
  final PublicacionLikesRepository repository;

  CreatePublicacionLike({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    PublicacionLike like,
  ) async {
    return await repository
        .createPublicacionLike(
      like,
    );
  }
}