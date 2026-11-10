import type { ProjectRole } from "../entities/project_role";
import type { RegistroRoble } from "../entities/types";

export interface ProjectRolesRepository {
  createProjectRole(projectRole: ProjectRole): Promise<RegistroRoble>;
  getRolesByProject(idProyecto: number): Promise<RegistroRoble[]>;
}
