import type {
  Publicacion,
  RegistroPublicacion,
} from "../entities/publicacion";
import type { PublicacionRepository } from "../repositories/publicacion_repository";

export class CreatePublicacion {
  constructor(private readonly repository: PublicacionRepository) {}

  execute(publicacion: Publicacion): Promise<RegistroPublicacion> {
    return this.repository.createPublicacion(publicacion);
  }
}
