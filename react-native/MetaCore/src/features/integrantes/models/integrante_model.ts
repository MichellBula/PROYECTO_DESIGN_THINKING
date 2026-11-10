import { Integrante } from "../domain/entities/integrante";

// Traduce la entidad a la estructura de la tabla `integrantes`.
export class IntegranteModel extends Integrante {
  static fromEntity(integrante: Integrante): IntegranteModel {
    return new IntegranteModel(
      integrante.idUsuario,
      integrante.idProyecto,
      integrante.idRol
    );
  }

  toMap(params: {
    idUsuarioIntegrante: number;
  }): Record<string, number> {
    return {
      id_usuario_integrante: params.idUsuarioIntegrante,
      id_usuario: this.idUsuario,
      id_proyecto: this.idProyecto,
      id_rol: this.idRol,
    };
  }
}
