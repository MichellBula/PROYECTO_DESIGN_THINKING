import { Solicitud } from "../domain/entities/solicitud";

export class SolicitudModel extends Solicitud {
  static fromEntity(solicitud: Solicitud): SolicitudModel {
    return new SolicitudModel(
      solicitud.idProyecto,
      solicitud.idUsuario,
      solicitud.estado,
      solicitud.fechaEnviada,
      solicitud.fechaRespuesta,
      solicitud.idProyectoRol,
      solicitud.comentario
    );
  }

  toMap(params: { idSolicitud: number }): Record<string, string | number | null> {
    return {
      id_solicitud: params.idSolicitud,
      id_proyecto: this.idProyecto,
      id_usuario: this.idUsuario,
      estado: this.estado,
      fecha_enviada: this.fechaEnviada.toISOString(),
      fecha_respuesta: this.fechaRespuesta?.toISOString() ?? null,
      id_proyecto_rol: this.idProyectoRol,
      comentario: this.comentario.trim(),
    };
  }
}
