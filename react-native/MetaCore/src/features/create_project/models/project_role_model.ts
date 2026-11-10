import { ProjectRole } from "../domain/entities/project_role";
import type { RegistroRoble } from "../domain/entities/types";

export class ProjectRoleModel extends ProjectRole {
  static fromEntity(r: ProjectRole): ProjectRoleModel {
    return new ProjectRoleModel(r.idProyecto, r.idRol, r.cantidad);
  }
  toMap(params: { idProyectoRol: number }): RegistroRoble {
    return { id_proyecto_rol: params.idProyectoRol,
      id_proyecto: this.idProyecto, id_rol: this.idRol, cantidad: this.cantidad };
  }
}
