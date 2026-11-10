import type { Etapa, RegistroEtapa } from "../entities/etapa";
import type { EtapaRepository } from "../repositories/etapa_repository";

export class CreateEtapa {
  constructor(private readonly repository: EtapaRepository) {}
  execute(etapa: Etapa): Promise<RegistroEtapa> {
    return this.repository.createEtapa(etapa);
  }
}
