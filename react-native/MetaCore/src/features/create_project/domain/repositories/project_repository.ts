import type { Project } from "../entities/project";
import type { RegistroRoble } from "../entities/types";

export interface ProjectRepository {
  createProject(project: Project): Promise<RegistroRoble>;
  calificarProyecto(idProyecto: number, calificacion: number): Promise<RegistroRoble>;
}
