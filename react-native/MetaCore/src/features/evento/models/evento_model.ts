import { Evento } from "../domain/entities/evento";

// Adaptador entre la entidad y las columnas de la tabla `evento` de Roble.
export class EventoModel extends Evento {
  static fromEntity(evento: Evento): EventoModel {
    return new EventoModel(
      evento.idProyecto,
      evento.nombre,
      evento.tipoEvento,
      evento.descripcion,
      evento.fechaInicio,
      evento.fechaFinal
    );
  }

  toMap({ idEvento }: { idEvento: number }): Record<string, string | number> {
    return {
      id_evento: idEvento,
      id_proyecto: this.idProyecto,
      nombre: this.nombre,
      tipo_evento: this.tipoEvento,
      descripcion: this.descripcion,
      fecha_inicio: this.fechaInicio.toISOString(),
      fecha_final: this.fechaFinal.toISOString(),
    };
  }
}
