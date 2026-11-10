import type { CreateProjectRequest } from "../domain/entities/create_project_request";
import type { RegistroRoble } from "../domain/entities/types";
import type { CreateCompleteProject } from "../domain/usecases/create_complete_project";

export class PublishProjectController {
  isLoading = false;
  constructor(private readonly createCompleteProject: Pick<CreateCompleteProject, "execute">) {}

  async publicar(params: Omit<CreateProjectRequest, "fechaInicio" | "fechaCierre"> & {
    fechaInicio: Date | null; fechaCierre: Date | null;
  }): Promise<RegistroRoble | null> {
    if (this.isLoading) return null;
    if (!params.fechaInicio || !params.fechaCierre) throw new Error("Faltan las fechas del proyecto.");

    this.isLoading = true;
    try {
      const request: CreateProjectRequest = {
        ...params,
        roles: [...params.roles],
        cantidadesPorRol: { ...params.cantidadesPorRol },
        habilidades: [...params.habilidades],
        fechaInicio: new Date(params.fechaInicio),
        fechaCierre: new Date(params.fechaCierre),
      };
      return await this.createCompleteProject.execute(request);
    } finally {
      this.isLoading = false;
    }
  }
}
