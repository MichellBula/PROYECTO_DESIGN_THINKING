import type { ProjectRole } from "../entities/project_role";
import type { RegistroRoble } from "../entities/types";
import type { ProjectRolesRepository } from "../repositories/project_roles_repository";

// El Dart original contenía accidentalmente una copia de ProjectSkillModel.
export class CreateProjectRole {
  constructor(private readonly repository: ProjectRolesRepository) {}
  execute(role: ProjectRole): Promise<RegistroRoble> { return this.repository.createProjectRole(role); }
}
