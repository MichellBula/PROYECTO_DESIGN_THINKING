import '../entities/publicacion_like.dart';

abstract class PublicacionLikesRepository {
  Future<Map<String, dynamic>>
      createPublicacionLike(
    PublicacionLike like,
  );

  Future<List<Map<String, dynamic>>>
      getLikesByPublicacion(
    int idPublicacion,
  );

  Future<Map<String, dynamic>?>
      getPublicacionLikeByUserAndPublicacion({
    required int idUsuario,
    required int idPublicacion,
  });
}