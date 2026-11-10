import type { RegistroPublicacion } from "../entities/publicacion";
import type { PublicacionRepository } from "../repositories/publicacion_repository";

export class GetPublicacionesByProject {
  constructor(private readonly repository: PublicacionRepository) {}

  execute(idProyecto: number): Promise<RegistroPublicacion[]> {
    return this.repository.getPublicacionesByProject(idProyecto);
  }
}
