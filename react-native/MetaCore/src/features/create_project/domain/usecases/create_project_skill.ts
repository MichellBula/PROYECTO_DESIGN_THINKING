import type { ProjectSkill } from "../entities/project_skill";
import type { RegistroRoble } from "../entities/types";
import type { ProjectSkillsRepository } from "../repositories/project_skills_repository";

export class CreateProjectSkill {
  constructor(private readonly repository: ProjectSkillsRepository) {}
  execute(skill: ProjectSkill): Promise<RegistroRoble> { return this.repository.createProjectSkill(skill); }
}
