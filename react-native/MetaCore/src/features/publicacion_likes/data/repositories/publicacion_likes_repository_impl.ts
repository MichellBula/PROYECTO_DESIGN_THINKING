import type {
  PublicacionLike,
  RegistroPublicacionLike,
  UsuarioYPublicacion,
} from "../../domain/entities/publicacion_like";
import type { PublicacionLikesRepository } from "../../domain/repositories/publicacion_likes_repository";
import { PublicacionLikeModel } from "../../models/publicacion_like_model";
import { PublicacionLikesRemoteDatasource } from "../datasources/publicacion_likes_remote_datasource";

export class PublicacionLikesRepositoryImpl implements PublicacionLikesRepository {
  constructor(private readonly datasource: PublicacionLikesRemoteDatasource) {}

  createPublicacionLike(like: PublicacionLike): Promise<RegistroPublicacionLike> {
    return this.datasource.createPublicacionLike(
      PublicacionLikeModel.fromEntity(like)
    );
  }

  getLikesByPublicacion(idPublicacion: number): Promise<RegistroPublicacionLike[]> {
    return this.datasource.getLikesByPublicacion(idPublicacion);
  }

  getPublicacionLikeByUserAndPublicacion(
    params: UsuarioYPublicacion
  ): Promise<RegistroPublicacionLike | null> {
    return this.datasource.getPublicacionLikeByUserAndPublicacion(params);
  }

  deletePublicacionLikeByUserAndPublicacion(
    params: UsuarioYPublicacion
  ): Promise<boolean> {
    return this.datasource.deletePublicacionLikeByUserAndPublicacion(params);
  }
}
