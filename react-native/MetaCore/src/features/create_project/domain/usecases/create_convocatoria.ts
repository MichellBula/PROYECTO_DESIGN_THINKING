import type { Convocatoria } from "../entities/convocatoria";
import type { RegistroRoble } from "../entities/types";
import type { ConvocatoriaRepository } from "../repositories/convocatoria_repository";

export class CreateConvocatoria {
  constructor(private readonly repository: ConvocatoriaRepository) {}
  execute(convocatoria: Convocatoria): Promise<RegistroRoble> { return this.repository.createConvocatoria(convocatoria); }
}
