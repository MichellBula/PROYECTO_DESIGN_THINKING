import type { RegistroAvance } from "../entities/avance";
import type { AvanceRepository } from "../repositories/avance_repository";

export class GetAvanceById {
  constructor(private readonly repository: AvanceRepository) {}

  execute(idAvance: number): Promise<RegistroAvance | null> {
    return this.repository.getAvanceById(idAvance);
  }
}
