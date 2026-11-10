import type { RegistroPublicacion } from "../entities/publicacion";
import type { PublicacionRepository } from "../repositories/publicacion_repository";

export class GetTodasLasPublicaciones {
  constructor(private readonly repository: PublicacionRepository) {}

  execute(): Promise<RegistroPublicacion[]> {
    return this.repository.getTodasLasPublicaciones();
  }
}
