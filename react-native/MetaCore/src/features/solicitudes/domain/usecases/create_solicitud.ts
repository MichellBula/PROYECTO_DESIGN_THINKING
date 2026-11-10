import type { Solicitud, RegistroSolicitud } from "../entities/solicitud";
import type { SolicitudRepository } from "../repositories/solicitud_repository";

export class CreateSolicitud {
  constructor(private readonly repository: SolicitudRepository) {}

  execute(solicitud: Solicitud): Promise<RegistroSolicitud> {
    return this.repository.createSolicitud(solicitud);
  }
}
