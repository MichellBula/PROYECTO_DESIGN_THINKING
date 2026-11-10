import type { Solicitud, RegistroSolicitud } from "../entities/solicitud";

export interface SolicitudRepository {
  createSolicitud(solicitud: Solicitud): Promise<RegistroSolicitud>;
  getMisSolicitudes(idUsuario: number): Promise<RegistroSolicitud[]>;
  getSolicitudesPendientesDeMisProyectos(
    idUsuario: number
  ): Promise<RegistroSolicitud[]>;
  getSolicitudById(idSolicitud: number): Promise<RegistroSolicitud | null>;
  responderSolicitud(params: {
    idSolicitud: number;
    nuevoEstado: string;
  }): Promise<RegistroSolicitud>;
  getIdUsuarioAutenticado(): Promise<number>;
  getIdCreadorDelProyecto(idProyecto: number): Promise<number>;
  getProyectoRolById(idProyectoRol: number): Promise<RegistroSolicitud | null>;
}
