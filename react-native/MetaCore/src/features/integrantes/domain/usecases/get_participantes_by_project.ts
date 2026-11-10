import type { ParticipanteDetalle } from "../entities/integrante";
import type { IntegranteRepository } from "../repositories/integrante_repository";

// Caso de uso adicional para desacoplar el controlador de los accesos a Roble.
export class GetParticipantesByProject {
  constructor(private readonly repository: IntegranteRepository) {}

  execute(idProyecto: number): Promise<ParticipanteDetalle[]> {
    return this.repository.getParticipantesByProject(idProyecto);
  }
}
