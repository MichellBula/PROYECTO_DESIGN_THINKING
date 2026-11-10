import { Convocatoria } from "../domain/entities/convocatoria";
import type { RegistroRoble } from "../domain/entities/types";

export class ConvocatoriaModel extends Convocatoria {
  static fromEntity(c: Convocatoria): ConvocatoriaModel {
    return new ConvocatoriaModel(c.idProyecto, c.fechaInicio, c.fechaFinal,
      c.estado, c.fechaLimiteDeAbandono);
  }
  toMap(): RegistroRoble {
    return {
      id_proyecto: this.idProyecto,
      fecha_inicio: this.fechaInicio.toISOString(),
      fecha_final: this.fechaFinal.toISOString(),
      estado: this.estado,
      fecha_limite_de_abandono: this.fechaLimiteDeAbandono?.toISOString() ?? null,
    };
  }
}
