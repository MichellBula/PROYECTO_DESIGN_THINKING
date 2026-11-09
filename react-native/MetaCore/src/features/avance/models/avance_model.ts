import { Avance, type RegistroAvance } from "../domain/entities/avance";

export class AvanceModel extends Avance {
  static fromEntity(avance: Avance): AvanceModel {
    return new AvanceModel(
      avance.idEtapa,
      avance.comentario,
      avance.fecha
    );
  }

  toMap(params: { idAvance: number }): RegistroAvance {
    return {
      id_avance: params.idAvance,
      id_etapa: this.idEtapa,
      comentario: this.comentario.trim(),
      fecha: this.fecha.toISOString(),
    };
  }
}
