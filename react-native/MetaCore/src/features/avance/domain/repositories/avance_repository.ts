import type { Avance, RegistroAvance } from "../entities/avance";

export interface AvanceRepository {
  createAvance(avance: Avance): Promise<RegistroAvance>;
  getAvanceById(idAvance: number): Promise<RegistroAvance | null>;
  getAvancesByEtapa(idEtapa: number): Promise<RegistroAvance[]>;
  getAvancesByProject(idProyecto: number): Promise<RegistroAvance[]>;
  getPorcentajeByEtapa(idEtapa: number): Promise<number>;
}
