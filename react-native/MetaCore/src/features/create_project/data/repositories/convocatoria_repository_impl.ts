import type { Convocatoria } from "../../domain/entities/convocatoria";
import type { RegistroRoble } from "../../domain/entities/types";
import type { ConvocatoriaRepository } from "../../domain/repositories/convocatoria_repository";
import { ConvocatoriaModel } from "../../models/convocatoria_model";
import type { ConvocatoriaRemoteDatasource } from "../datasources/convocatoria_remote_datasource";

export class ConvocatoriaRepositoryImpl implements ConvocatoriaRepository {
  constructor(private readonly datasource: ConvocatoriaRemoteDatasource) {}
  createConvocatoria(convocatoria: Convocatoria): Promise<RegistroRoble> {
    return this.datasource.createConvocatoria(ConvocatoriaModel.fromEntity(convocatoria));
  }
  getConvocatoriaByProject(idProyecto: number): Promise<RegistroRoble | null> {
    return this.datasource.getConvocatoriaByProject(idProyecto);
  }
}
