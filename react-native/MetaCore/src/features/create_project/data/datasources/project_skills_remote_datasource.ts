import type { RobleApiClient } from "roble-client";
import type { RegistroRoble } from "../../domain/entities/types";
import { ProjectSkillModel } from "../../models/project_skill_model";
import { firstRow, nextId } from "./roble_utils";

export class ProjectSkillsRemoteDatasource {
  constructor(private readonly roble: RobleApiClient) {}

  private findRelation(skill: ProjectSkillModel): Promise<RegistroRoble | null> {
    return firstRow(this.roble, "proyecto_habilidades", {
      id_proyecto: skill.idProyecto, id_habilidad: skill.idHabilidad,
    });
  }

  async createProjectSkill(skill: ProjectSkillModel): Promise<RegistroRoble> {
    const existente = await this.findRelation(skill);
    if (existente) return existente;

    for (let intento = 1; intento <= 5; intento++) {
      const id = await nextId(this.roble, "proyecto_habilidades", "id_proyecto_habilidad");
      try {
        return await this.roble.create("proyecto_habilidades", skill.toMap({ idProyectoHabilidad: id }));
      } catch (error) {
        const recuperada = await this.findRelation(skill);
        if (recuperada) return recuperada;
        if (!(await firstRow(this.roble, "proyecto_habilidades", { id_proyecto_habilidad: id })) || intento === 5) {
          throw error;
        }
      }
    }
    throw new Error("No fue posible crear la relación proyecto-habilidad.");
  }

  async getSkillsByProject(idProyecto: number): Promise<RegistroRoble[]> {
    return (await this.roble.read("proyecto_habilidades", { id_proyecto: idProyecto })).map(row => ({ ...row }));
  }
}
