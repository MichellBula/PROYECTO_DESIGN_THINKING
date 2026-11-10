import type { RobleApiClient } from "roble-client";
import type { RegistroRoble } from "../../domain/entities/types";
import { ProjectRoleModel } from "../../models/project_role_model";
import { firstRow, nextId } from "./roble_utils";

export class ProjectRolesRemoteDatasource {
  constructor(private readonly roble: RobleApiClient) {}

  private findRelation(role: ProjectRoleModel): Promise<RegistroRoble | null> {
    return firstRow(this.roble, "proyecto_roles", {
      id_proyecto: role.idProyecto, id_rol: role.idRol,
    });
  }

  async createProjectRole(role: ProjectRoleModel): Promise<RegistroRoble> {
    if (role.cantidad <= 0) throw new Error("La cantidad de integrantes debe ser mayor que 0.");
    const existente = await this.findRelation(role);
    if (existente) return existente;

    for (let intento = 1; intento <= 5; intento++) {
      const id = await nextId(this.roble, "proyecto_roles", "id_proyecto_rol");
      try {
        return await this.roble.create("proyecto_roles", role.toMap({ idProyectoRol: id }));
      } catch (error) {
        const recuperada = await this.findRelation(role);
        if (recuperada) return recuperada;
        if (!(await firstRow(this.roble, "proyecto_roles", { id_proyecto_rol: id })) || intento === 5) {
          throw error;
        }
      }
    }
    throw new Error("No fue posible crear la relación proyecto-rol.");
  }

  async getRolesByProject(idProyecto: number): Promise<RegistroRoble[]> {
    return (await this.roble.read("proyecto_roles", { id_proyecto: idProyecto })).map(row => ({ ...row }));
  }
}
