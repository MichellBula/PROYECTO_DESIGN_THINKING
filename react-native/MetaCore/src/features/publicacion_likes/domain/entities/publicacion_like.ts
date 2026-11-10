// Entidad de dominio, independiente de React Native y Roble.
export class PublicacionLike {
  constructor(
    public readonly idUsuario: number,
    public readonly idPublicacion: number
  ) {}
}

export type RegistroPublicacionLike = Record<string, unknown>;

export interface UsuarioYPublicacion {
  idUsuario: number;
  idPublicacion: number;
}
