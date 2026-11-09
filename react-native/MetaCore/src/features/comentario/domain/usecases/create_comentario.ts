import type { Comentario, RegistroComentario } from "../entities/comentario";
import type { ComentarioRepository } from "../repositories/comentario_repository";

export class CreateComentario {
  constructor(private readonly repository: ComentarioRepository) {}

  execute(comentario: Comentario): Promise<RegistroComentario> {
    return this.repository.createComentario(comentario);
  }
}
