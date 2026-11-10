import type { CrearUsuarioParams, Usuario } from "../../domain/entities/usuario";

// Contrato para las operaciones de usuario en la base de datos.
export interface UsuarioRemoteDataSource {
  crearUsuario(params: CrearUsuarioParams): Promise<Usuario>;
  obtenerUsuarioActual(idAutenticador: string): Promise<Usuario | null>;
  obtenerUsuarioPorId(idUsuario: number): Promise<Usuario | null>;
}
