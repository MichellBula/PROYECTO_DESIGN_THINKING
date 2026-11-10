import type { RegistroIntegrante } from "../entities/integrante";
import type { IntegranteRepository } from "../repositories/integrante_repository";

export class GetIntegrantesByProject {
  constructor(private readonly repository: IntegranteRepository) {}

  execute(idProyecto: number): Promise<RegistroIntegrante[]> {
    return this.repository.getIntegrantesByProject(idProyecto);
  }
}
