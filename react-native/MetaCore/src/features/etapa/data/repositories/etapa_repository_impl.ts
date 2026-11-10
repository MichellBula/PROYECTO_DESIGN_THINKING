import type { Etapa, RegistroEtapa } from "../../domain/entities/etapa";
import type { EtapaRepository } from "../../domain/repositories/etapa_repository";
import { EtapaModel } from "../../models/etapa_model";
import type { EtapaRemoteDatasource } from "../datasource/etapa_remote_datasource";

export class EtapaRepositoryImpl implements EtapaRepository {
  constructor(private readonly datasource: EtapaRemoteDatasource) {}

  createEtapa(etapa: Etapa): Promise<RegistroEtapa> {
    return this.datasource.createEtapa(EtapaModel.fromEntity(etapa));
  }

  getEtapaById(idEtapa: number): Promise<RegistroEtapa | null> {
    return this.datasource.getEtapaById(idEtapa);
  }

  getEtapasByProject(idProyecto: number): Promise<RegistroEtapa[]> {
    return this.datasource.getEtapasByProject(idProyecto);
  }
}
