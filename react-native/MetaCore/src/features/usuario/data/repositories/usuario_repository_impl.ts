import type { CrearUsuarioParams, Usuario } from "../../domain/entities/usuario";
import type { UsuarioRepository } from "../../domain/repositories/usuario_repository";
import type { UsuarioRemoteDataSource } from "../datasources/usuario_remote_data_source";

export class UsuarioRepositoryImpl implements UsuarioRepository {
  constructor(private readonly remoteDataSource: UsuarioRemoteDataSource) {}

  crearUsuario(params: CrearUsuarioParams): Promise<Usuario> {
    return this.remoteDataSource.crearUsuario(params);
  }

  obtenerUsuarioActual(idAutenticador: string): Promise<Usuario | null> {
    return this.remoteDataSource.obtenerUsuarioActual(idAutenticador);
  }

  obtenerUsuarioPorId(idUsuario: number): Promise<Usuario | null> {
    return this.remoteDataSource.obtenerUsuarioPorId(idUsuario);
  }
}
