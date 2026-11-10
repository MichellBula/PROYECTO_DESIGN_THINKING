import type { RegistroSolicitud } from "../entities/solicitud";
import type { SolicitudRepository } from "../repositories/solicitud_repository";

export class GetSolicitudesPendientes {
  constructor(private readonly repository: SolicitudRepository) {}

  execute(idUsuario: number): Promise<RegistroSolicitud[]> {
    return this.repository.getSolicitudesPendientesDeMisProyectos(idUsuario);
  }
}
