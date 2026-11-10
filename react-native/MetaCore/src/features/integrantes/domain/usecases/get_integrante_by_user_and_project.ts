import type { RegistroIntegrante } from "../entities/integrante";
import type { IntegranteRepository } from "../repositories/integrante_repository";

export class GetIntegranteByUserAndProject {
  constructor(private readonly repository: IntegranteRepository) {}

  execute(params: {
    idUsuario: number;
    idProyecto: number;
  }): Promise<RegistroIntegrante | null> {
    return this.repository.getIntegranteByUserAndProject(params);
  }
}
