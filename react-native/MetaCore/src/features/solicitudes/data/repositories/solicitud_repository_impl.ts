import type { Solicitud, RegistroSolicitud } from "../../domain/entities/solicitud";
import type { SolicitudRepository } from "../../domain/repositories/solicitud_repository";
import { SolicitudModel } from "../../models/solicitud_model";
import { SolicitudRemoteDatasource } from "../datasources/solicitud_remote_datasource";

export class SolicitudRepositoryImpl implements SolicitudRepository {
  constructor(private readonly datasource: SolicitudRemoteDatasource) {}

  createSolicitud(solicitud: Solicitud): Promise<RegistroSolicitud> {
    return this.datasource.createSolicitud(SolicitudModel.fromEntity(solicitud));
  }

  getMisSolicitudes(idUsuario: number): Promise<RegistroSolicitud[]> {
    return this.datasource.getMisSolicitudes(idUsuario);
  }

  getSolicitudesPendientesDeMisProyectos(
    idUsuario: number
  ): Promise<RegistroSolicitud[]> {
    return this.datasource.getSolicitudesPendientesDeMisProyectos(idUsuario);
  }

  getSolicitudById(idSolicitud: number): Promise<RegistroSolicitud | null> {
    return this.datasource.getSolicitudById(idSolicitud);
  }

  responderSolicitud(params: {
    idSolicitud: number;
    nuevoEstado: string;
  }): Promise<RegistroSolicitud> {
    return this.datasource.responderSolicitud(params);
  }

  getIdUsuarioAutenticado(): Promise<number> {
    return this.datasource.getIdUsuarioAutenticado();
  }

  getIdCreadorDelProyecto(idProyecto: number): Promise<number> {
    return this.datasource.getIdCreadorDelProyecto(idProyecto);
  }

  getProyectoRolById(idProyectoRol: number): Promise<RegistroSolicitud | null> {
    return this.datasource.getProyectoRolById(idProyectoRol);
  }
}
