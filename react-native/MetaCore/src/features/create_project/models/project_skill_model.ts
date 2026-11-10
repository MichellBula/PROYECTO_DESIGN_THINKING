import { ProjectSkill } from "../domain/entities/project_skill";
import type { RegistroRoble } from "../domain/entities/types";

export class ProjectSkillModel extends ProjectSkill {
  static fromEntity(s: ProjectSkill): ProjectSkillModel {
    return new ProjectSkillModel(s.idProyecto, s.idHabilidad);
  }
  toMap(params: { idProyectoHabilidad: number }): RegistroRoble {
    return { id_proyecto_habilidad: params.idProyectoHabilidad,
      id_proyecto: this.idProyecto, id_habilidad: this.idHabilidad };
  }
}
