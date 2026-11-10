import type { Project } from "../entities/project";
import type { RegistroRoble } from "../entities/types";
import type { ProjectRepository } from "../repositories/project_repository";

export class CreateProject {
  constructor(private readonly repository: ProjectRepository) {}
  execute(project: Project): Promise<RegistroRoble> { return this.repository.createProject(project); }
}
