// Entidad del dominio. No depende de React ni de Roble.
export class Etapa {
  constructor(
    public readonly idProyecto: number,
    public readonly nombreEtapa: string,
    public readonly orden: number
  ) {}
}

export type RegistroEtapa = Record<string, unknown>;
