// Entidad de dominio, independiente de React Native y Roble.
export class Integrante {
  constructor(
    public readonly idUsuario: number,
    public readonly idProyecto: number,
    public readonly idRol: number
  ) {}
}

export type RegistroIntegrante = Record<string, unknown>;

// Datos enriquecidos que el dominio entrega a la presentación.
export interface ParticipanteDetalle {
  nombreUsuario: string;
  nombreRol: string;
}
