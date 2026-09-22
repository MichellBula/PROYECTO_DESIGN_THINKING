import '../repositories/publicacion_likes_repository.dart';

class GetPublicacionLikeByUserAndPublicacion {
  final PublicacionLikesRepository repository;

  GetPublicacionLikeByUserAndPublicacion({
    required this.repository,
  });

  Future<Map<String, dynamic>?> call({
    required int idUsuario,
    required int idPublicacion,
  }) async {
    return await repository
        .getPublicacionLikeByUserAndPublicacion(
      idUsuario: idUsuario,
      idPublicacion: idPublicacion,
    );
  }
}