import type { RegistroPublicacionLike } from "../entities/publicacion_like";
import type { PublicacionLikesRepository } from "../repositories/publicacion_likes_repository";

export class GetLikesByPublicacion {
  constructor(private readonly repository: PublicacionLikesRepository) {}

  execute(idPublicacion: number): Promise<RegistroPublicacionLike[]> {
    return this.repository.getLikesByPublicacion(idPublicacion);
  }
}
