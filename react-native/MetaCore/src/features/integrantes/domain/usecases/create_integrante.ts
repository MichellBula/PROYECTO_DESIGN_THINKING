import type { Integrante, RegistroIntegrante } from "../entities/integrante";
import type { IntegranteRepository } from "../repositories/integrante_repository";

export class CreateIntegrante {
  constructor(private readonly repository: IntegranteRepository) {}

  execute(integrante: Integrante): Promise<RegistroIntegrante> {
    return this.repository.createIntegrante(integrante);
  }
}
