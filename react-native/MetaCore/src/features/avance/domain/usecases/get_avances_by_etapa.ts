import type { RegistroAvance } from "../entities/avance";
import type { AvanceRepository } from "../repositories/avance_repository";

export class GetAvancesByEtapa {
  constructor(private readonly repository: AvanceRepository) {}

  execute(idEtapa: number): Promise<RegistroAvance[]> {
    return this.repository.getAvancesByEtapa(idEtapa);
  }
}
