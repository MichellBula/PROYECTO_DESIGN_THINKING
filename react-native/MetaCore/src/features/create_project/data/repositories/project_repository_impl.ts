import type { Project } from "../../domain/entities/project";
import type { RegistroRoble } from "../../domain/entities/types";
import type { ProjectRepository } from "../../domain/repositories/project_repository";
import { ProjectModel } from "../../models/project_model";
import type { ProjectRemoteDatasource } from "../datasources/project_remote_datasource";

export class ProjectRepositoryImpl implements ProjectRepository {
  constructor(private readonly datasource: ProjectRemoteDatasource) {}
  createProject(project: Project): Promise<RegistroRoble> {
    return this.datasource.createProject(ProjectModel.fromEntity(project));
  }
  calificarProyecto(idProyecto: number, calificacion: number): Promise<RegistroRoble> {
    return this.datasource.calificarProyecto({ idProyecto, calificacion });
  }
}
