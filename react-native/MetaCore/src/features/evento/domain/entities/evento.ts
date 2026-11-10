// Entidad de dominio: no depende de React Native ni del SDK de Roble.
export class Evento {
  constructor(
    public readonly idProyecto: number,
    public readonly nombre: string,
    public readonly tipoEvento: string,
    public readonly descripcion: string,
    public readonly fechaInicio: Date,
    public readonly fechaFinal: Date
  ) {}
}

export type RegistroEvento = Record<string, unknown>;
