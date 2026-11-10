import type { CreateProjectRequest } from "../entities/create_project_request";
import type { RegistroRoble } from "../entities/types";

// El caso de uso depende de una abstracción, no de una clase del SDK Roble.
export interface CompleteProjectCreator {
  crearProyectoCompleto(request: CreateProjectRequest): Promise<RegistroRoble>;
}

export class CreateCompleteProject {
  constructor(private readonly creator: CompleteProjectCreator) {}

  execute(request: CreateProjectRequest): Promise<RegistroRoble> {
    return this.creator.crearProyectoCompleto(request);
  }
}
