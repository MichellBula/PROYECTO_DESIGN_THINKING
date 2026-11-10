import type {
  Integrante,
  ParticipanteDetalle,
  RegistroIntegrante,
} from "../../domain/entities/integrante";
import type { IntegranteRepository } from "../../domain/repositories/integrante_repository";
import { IntegranteModel } from "../../models/integrante_model";
import { IntegranteRemoteDatasource } from "../datasources/integrante_remote_datasource";

export class IntegranteRepositoryImpl implements IntegranteRepository {
  constructor(private readonly datasource: IntegranteRemoteDatasource) {}

  createIntegrante(integrante: Integrante): Promise<RegistroIntegrante> {
    return this.datasource.createIntegrante(IntegranteModel.fromEntity(integrante));
  }

  createIntegranteSimple(params: {
    idUsuario: number;
    idProyecto: number;
    idRol: number;
  }): Promise<RegistroIntegrante> {
    return this.datasource.createIntegranteSimple(params);
  }

  getIntegrantesByProject(idProyecto: number): Promise<RegistroIntegrante[]> {
    return this.datasource.getIntegrantesByProject(idProyecto);
  }

  getIntegranteByUserAndProject(params: {
    idUsuario: number;
    idProyecto: number;
  }): Promise<RegistroIntegrante | null> {
    return this.datasource.getIntegranteByUserAndProject(params);
  }

  getParticipantesByProject(idProyecto: number): Promise<ParticipanteDetalle[]> {
    return this.datasource.getParticipantesByProject(idProyecto);
  }
}
