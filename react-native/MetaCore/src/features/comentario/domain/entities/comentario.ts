// Entidad de dominio: no depende de Roble, React Native ni la capa de datos.
export class Comentario {
  constructor(
    public readonly idPublicacion: number,
    public readonly idUsuario: number,
    public readonly contenido: string,
    public readonly fechaComentario: Date
  ) {}
}

// Equivalente de Map<String, dynamic> en los datos recibidos de Roble.
export type RegistroComentario = Record<string, unknown>;
