import type { Comentario, RegistroComentario } from "../entities/comentario";

// Contrato del dominio; no conoce los detalles de la API.
export interface ComentarioRepository {
  createComentario(comentario: Comentario): Promise<RegistroComentario>;
  getComentariosByPublicacion(idPublicacion: number): Promise<RegistroComentario[]>;
  getComentarioById(idComentario: number): Promise<RegistroComentario | null>;
}
