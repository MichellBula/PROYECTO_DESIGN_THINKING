import { Etapa, type RegistroEtapa } from "../domain/entities/etapa";

export class EtapaModel extends Etapa {
  static fromEntity(etapa: Etapa): EtapaModel {
    return new EtapaModel(etapa.idProyecto, etapa.nombreEtapa, etapa.orden);
  }

  toMap(params: { idEtapa: number }): RegistroEtapa {
    return {
      id_etapa: params.idEtapa,
      id_proyecto: this.idProyecto,
      nombre_etapa: this.nombreEtapa,
      orden: this.orden,
    };
  }
}
