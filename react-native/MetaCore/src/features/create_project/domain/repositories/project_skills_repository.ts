import type { ProjectSkill } from "../entities/project_skill";
import type { RegistroRoble } from "../entities/types";

export interface ProjectSkillsRepository {
  createProjectSkill(projectSkill: ProjectSkill): Promise<RegistroRoble>;
  getSkillsByProject(idProyecto: number): Promise<RegistroRoble[]>;
}
