import type { RegistroRoble } from "../entities/types";
import type { ProjectRepository } from "../repositories/project_repository";

export class CalificarProyecto {
  constructor(private readonly repository: ProjectRepository) {}
  execute(params: { idProyecto: number; calificacion: number }): Promise<RegistroRoble> {
    return this.repository.calificarProyecto(params.idProyecto, params.calificacion);
  }
}
