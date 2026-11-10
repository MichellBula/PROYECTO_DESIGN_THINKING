import type { Etapa, RegistroEtapa } from "../entities/etapa";

export interface EtapaRepository {
  createEtapa(etapa: Etapa): Promise<RegistroEtapa>;
  getEtapaById(idEtapa: number): Promise<RegistroEtapa | null>;
  getEtapasByProject(idProyecto: number): Promise<RegistroEtapa[]>;
}
