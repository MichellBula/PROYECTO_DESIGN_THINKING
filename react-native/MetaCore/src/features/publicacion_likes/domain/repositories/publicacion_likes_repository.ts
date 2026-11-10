import type {
  PublicacionLike,
  RegistroPublicacionLike,
  UsuarioYPublicacion,
} from "../entities/publicacion_like";

export interface PublicacionLikesRepository {
  createPublicacionLike(like: PublicacionLike): Promise<RegistroPublicacionLike>;
  getLikesByPublicacion(idPublicacion: number): Promise<RegistroPublicacionLike[]>;
  getPublicacionLikeByUserAndPublicacion(
    params: UsuarioYPublicacion
  ): Promise<RegistroPublicacionLike | null>;
  deletePublicacionLikeByUserAndPublicacion(
    params: UsuarioYPublicacion
  ): Promise<boolean>;
}
