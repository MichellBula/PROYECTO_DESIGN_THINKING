import type {
  PublicacionLike,
  RegistroPublicacionLike,
} from "../entities/publicacion_like";
import type { PublicacionLikesRepository } from "../repositories/publicacion_likes_repository";

export class CreatePublicacionLike {
  constructor(private readonly repository: PublicacionLikesRepository) {}

  execute(like: PublicacionLike): Promise<RegistroPublicacionLike> {
    return this.repository.createPublicacionLike(like);
  }
}
