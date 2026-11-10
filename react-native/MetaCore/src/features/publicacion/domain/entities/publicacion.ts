// Entidad del dominio; no depende de React Native ni de Roble.
export class Publicacion {
  constructor(
    public readonly idProyecto: number,
    public readonly titulo: string,
    public readonly contenido: string,
    public readonly fechaPublicacion: Date
  ) {}
}

export type RegistroPublicacion = Record<string, unknown>;
