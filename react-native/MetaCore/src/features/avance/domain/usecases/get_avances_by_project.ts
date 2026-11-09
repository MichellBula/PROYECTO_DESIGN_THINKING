import type { RegistroAvance } from "../entities/avance";
import type { AvanceRepository } from "../repositories/avance_repository";

export class GetAvancesByProject {
  constructor(private readonly repository: AvanceRepository) {}

  execute(idProyecto: number): Promise<RegistroAvance[]> {
    return this.repository.getAvancesByProject(idProyecto);
  }
}
