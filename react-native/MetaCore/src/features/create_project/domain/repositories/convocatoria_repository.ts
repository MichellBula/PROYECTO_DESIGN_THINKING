import type { Convocatoria } from "../entities/convocatoria";
import type { RegistroRoble } from "../entities/types";

export interface ConvocatoriaRepository {
  createConvocatoria(convocatoria: Convocatoria): Promise<RegistroRoble>;
  getConvocatoriaByProject(idProyecto: number): Promise<RegistroRoble | null>;
}
