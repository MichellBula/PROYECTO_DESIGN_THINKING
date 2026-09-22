import '../domain/entities/publicacion_like.dart';

class PublicacionLikeModel extends PublicacionLike {
  const PublicacionLikeModel({
    required super.idUsuario,
    required super.idPublicacion,
  });

  factory PublicacionLikeModel.fromEntity(
    PublicacionLike like,
  ) {
    return PublicacionLikeModel(
      idUsuario: like.idUsuario,
      idPublicacion: like.idPublicacion,
    );
  }

  Map<String, dynamic> toMap({
    required int idPublicacionLikes,
  }) {
    return {
      'id_publicacion_likes': idPublicacionLikes,
      'id_usuario': idUsuario,
      'id_publicacion': idPublicacion,
    };
  }
}