import type { RegistroEtapa } from "../entities/etapa";
import type { EtapaRepository } from "../repositories/etapa_repository";

export class GetEtapasByProject {
  constructor(private readonly repository: EtapaRepository) {}
  execute(idProyecto: number): Promise<RegistroEtapa[]> {
    return this.repository.getEtapasByProject(idProyecto);
  }
}
