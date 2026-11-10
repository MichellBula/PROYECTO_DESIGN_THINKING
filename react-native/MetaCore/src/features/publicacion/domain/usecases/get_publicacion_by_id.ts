import type { RegistroPublicacion } from "../entities/publicacion";
import type { PublicacionRepository } from "../repositories/publicacion_repository";

export class GetPublicacionById {
  constructor(private readonly repository: PublicacionRepository) {}

  execute(idPublicacion: number): Promise<RegistroPublicacion | null> {
    return this.repository.getPublicacionById(idPublicacion);
  }
}
