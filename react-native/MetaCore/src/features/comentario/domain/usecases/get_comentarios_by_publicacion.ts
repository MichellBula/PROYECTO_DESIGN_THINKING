import type { RegistroComentario } from "../entities/comentario";
import type { ComentarioRepository } from "../repositories/comentario_repository";

export class GetComentariosByPublicacion {
  constructor(private readonly repository: ComentarioRepository) {}

  execute(idPublicacion: number): Promise<RegistroComentario[]> {
    return this.repository.getComentariosByPublicacion(idPublicacion);
  }
}
