import { PublicacionLike } from "../domain/entities/publicacion_like";

// Mapea el modelo al esquema de la tabla `publicacion_likes` de Roble.
export class PublicacionLikeModel extends PublicacionLike {
  static fromEntity(like: PublicacionLike): PublicacionLikeModel {
    return new PublicacionLikeModel(like.idUsuario, like.idPublicacion);
  }

  toMap(params: {
    idPublicacionLikes: number;
  }): Record<string, number> {
    return {
      id_publicacion_likes: params.idPublicacionLikes,
      id_usuario: this.idUsuario,
      id_publicacion: this.idPublicacion,
    };
  }
}
