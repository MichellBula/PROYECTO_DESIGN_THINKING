import type { RegistroSolicitud } from "../entities/solicitud";
import type { SolicitudRepository } from "../repositories/solicitud_repository";

export class ResponderSolicitud {
  constructor(private readonly repository: SolicitudRepository) {}

  execute(params: {
    idSolicitud: number;
    nuevoEstado: string;
  }): Promise<RegistroSolicitud> {
    return this.repository.responderSolicitud(params);
  }
}
