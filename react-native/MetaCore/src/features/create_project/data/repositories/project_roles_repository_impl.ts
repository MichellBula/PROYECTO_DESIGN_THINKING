import type { ProjectRole } from "../../domain/entities/project_role";
import type { RegistroRoble } from "../../domain/entities/types";
import type { ProjectRolesRepository } from "../../domain/repositories/project_roles_repository";
import { ProjectRoleModel } from "../../models/project_role_model";
import type { ProjectRolesRemoteDatasource } from "../datasources/project_roles_remote_datasource";

export class ProjectRolesRepositoryImpl implements ProjectRolesRepository {
  constructor(private readonly datasource: ProjectRolesRemoteDatasource) {}
  createProjectRole(role: ProjectRole): Promise<RegistroRoble> {
    return this.datasource.createProjectRole(ProjectRoleModel.fromEntity(role));
  }
  getRolesByProject(idProyecto: number): Promise<RegistroRoble[]> {
    return this.datasource.getRolesByProject(idProyecto);
  }
}
