import type { Comentario, RegistroComentario } from "../../domain/entities/comentario";
import type { ComentarioRepository } from "../../domain/repositories/comentario_repository";
import { ComentarioModel } from "../../models/comentario_model";
import type { ComentarioRemoteDatasource } from "../datasources/comentario_remote_datasource";

export class ComentarioRepositoryImpl implements ComentarioRepository {
  constructor(private readonly datasource: ComentarioRemoteDatasource) {}

  createComentario(comentario: Comentario): Promise<RegistroComentario> {
    const model = ComentarioModel.fromEntity(comentario);
    return this.datasource.createComentario(model);
  }

  getComentariosByPublicacion(idPublicacion: number): Promise<RegistroComentario[]> {
    return this.datasource.getComentariosByPublicacion(idPublicacion);
  }

  getComentarioById(idComentario: number): Promise<RegistroComentario | null> {
    return this.datasource.getComentarioById(idComentario);
  }
}
