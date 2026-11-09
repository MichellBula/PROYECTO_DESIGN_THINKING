import type { Avance, RegistroAvance } from "../entities/avance";
import type { AvanceRepository } from "../repositories/avance_repository";

export class CreateAvance {
  constructor(private readonly repository: AvanceRepository) {}

  execute(avance: Avance): Promise<RegistroAvance> {
    return this.repository.createAvance(avance);
  }
}
