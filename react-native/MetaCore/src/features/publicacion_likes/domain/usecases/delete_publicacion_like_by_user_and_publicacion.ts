import type { UsuarioYPublicacion } from "../entities/publicacion_like";
import type { PublicacionLikesRepository } from "../repositories/publicacion_likes_repository";

// Caso de uso adicional: el repositorio Dart ya exponía esta operación.
export class DeletePublicacionLikeByUserAndPublicacion {
  constructor(private readonly repository: PublicacionLikesRepository) {}

  execute(params: UsuarioYPublicacion): Promise<boolean> {
    return this.repository.deletePublicacionLikeByUserAndPublicacion(params);
  }
}
