import type {
  RegistroPublicacionLike,
  UsuarioYPublicacion,
} from "../entities/publicacion_like";
import type { PublicacionLikesRepository } from "../repositories/publicacion_likes_repository";

export class GetPublicacionLikeByUserAndPublicacion {
  constructor(private readonly repository: PublicacionLikesRepository) {}

  execute(params: UsuarioYPublicacion): Promise<RegistroPublicacionLike | null> {
    return this.repository.getPublicacionLikeByUserAndPublicacion(params);
  }
}
