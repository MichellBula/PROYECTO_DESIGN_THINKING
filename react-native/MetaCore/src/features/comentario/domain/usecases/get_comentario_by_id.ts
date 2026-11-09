import type { RegistroComentario } from "../entities/comentario";
import type { ComentarioRepository } from "../repositories/comentario_repository";

export class GetComentarioById {
  constructor(private readonly repository: ComentarioRepository) {}

  execute(idComentario: number): Promise<RegistroComentario | null> {
    return this.repository.getComentarioById(idComentario);
  }
}
