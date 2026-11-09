// Entidad del dominio: no depende de React, Roble ni de la interfaz gráfica.
export class Avance {
  constructor(
    public readonly idEtapa: number,
    public readonly comentario: string,
    public readonly fecha: Date
  ) {}
}

// Equivalente a Map<String, dynamic> para los registros recibidos de Roble.
export type RegistroAvance = Record<string, unknown>;
