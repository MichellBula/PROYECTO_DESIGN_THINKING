import type { ProjectSkill } from "../../domain/entities/project_skill";
import type { RegistroRoble } from "../../domain/entities/types";
import type { ProjectSkillsRepository } from "../../domain/repositories/project_skills_repository";
import { ProjectSkillModel } from "../../models/project_skill_model";
import type { ProjectSkillsRemoteDatasource } from "../datasources/project_skills_remote_datasource";

export class ProjectSkillsRepositoryImpl implements ProjectSkillsRepository {
  constructor(private readonly datasource: ProjectSkillsRemoteDatasource) {}
  createProjectSkill(skill: ProjectSkill): Promise<RegistroRoble> {
    return this.datasource.createProjectSkill(ProjectSkillModel.fromEntity(skill));
  }
  getSkillsByProject(idProyecto: number): Promise<RegistroRoble[]> {
    return this.datasource.getSkillsByProject(idProyecto);
  }
}
