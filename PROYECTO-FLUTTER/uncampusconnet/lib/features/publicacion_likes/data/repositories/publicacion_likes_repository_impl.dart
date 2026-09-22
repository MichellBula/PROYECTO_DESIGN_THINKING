import '../../domain/entities/publicacion_like.dart';
import '../../domain/repositories/publicacion_likes_repository.dart';
import '../../models/publicacion_like_model.dart';
import '../datasources/publicacion_likes_remote_datasource.dart';

class PublicacionLikesRepositoryImpl
    implements PublicacionLikesRepository {
  final PublicacionLikesRemoteDatasource datasource;

  PublicacionLikesRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>>
      createPublicacionLike(
    PublicacionLike like,
  ) async {
    final model =
        PublicacionLikeModel.fromEntity(
      like,
    );

    return await datasource
        .createPublicacionLike(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>>
      getLikesByPublicacion(
    int idPublicacion,
  ) {
    return datasource.getLikesByPublicacion(
      idPublicacion,
    );
  }

  @override
  Future<Map<String, dynamic>?>
      getPublicacionLikeByUserAndPublicacion({
    required int idUsuario,
    required int idPublicacion,
  }) {
    return datasource
        .getPublicacionLikeByUserAndPublicacion(
      idUsuario: idUsuario,
      idPublicacion: idPublicacion,
    );
  }
}