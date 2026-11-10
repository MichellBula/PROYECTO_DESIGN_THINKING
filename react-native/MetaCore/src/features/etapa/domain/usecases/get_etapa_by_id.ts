import type { RegistroEtapa } from "../entities/etapa";
import type { EtapaRepository } from "../repositories/etapa_repository";

export class GetEtapaById {
  constructor(private readonly repository: EtapaRepository) {}
  execute(idEtapa: number): Promise<RegistroEtapa | null> {
    return this.repository.getEtapaById(idEtapa);
  }
}
