import type { Avance, RegistroAvance } from "../../domain/entities/avance";
import type { AvanceRepository } from "../../domain/repositories/avance_repository";
import { AvanceModel } from "../../models/avance_model";
import { AvanceRemoteDatasource } from "../datasources/avance_remote_datasource";

export class AvanceRepositoryImpl implements AvanceRepository {
  constructor(private readonly datasource: AvanceRemoteDatasource) {}

  createAvance(avance: Avance): Promise<RegistroAvance> {
    return this.datasource.createAvance(AvanceModel.fromEntity(avance));
  }

  getAvanceById(idAvance: number): Promise<RegistroAvance | null> {
    return this.datasource.getAvanceById(idAvance);
  }

  getAvancesByEtapa(idEtapa: number): Promise<RegistroAvance[]> {
    return this.datasource.getAvancesByEtapa(idEtapa);
  }

  getAvancesByProject(idProyecto: number): Promise<RegistroAvance[]> {
    return this.datasource.getAvancesByProject(idProyecto);
  }

  getPorcentajeByEtapa(idEtapa: number): Promise<number> {
    return this.datasource.getPorcentajeByEtapa(idEtapa);
  }
}
