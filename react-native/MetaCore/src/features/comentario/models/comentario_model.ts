import { Comentario, type RegistroComentario } from "../domain/entities/comentario";

export class ComentarioModel extends Comentario {
  static fromEntity(comentario: Comentario): ComentarioModel {
    return new ComentarioModel(
      comentario.idPublicacion,
      comentario.idUsuario,
      comentario.contenido,
      comentario.fechaComentario
    );
  }

  toMap(params: { idComentario: number }): RegistroComentario {
    return {
      id_comentario: params.idComentario,
      id_publicacion: this.idPublicacion,
      id_usuario: this.idUsuario,
      contenido: this.contenido,
      fecha_comentario: this.fechaComentario.toISOString(),
    };
  }
}
