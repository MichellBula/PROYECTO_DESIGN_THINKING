import type { CrearUsuarioParams, Usuario } from "../entities/usuario";

export interface UsuarioRepository {
  crearUsuario(params: CrearUsuarioParams): Promise<Usuario>;
  obtenerUsuarioActual(idAutenticador: string): Promise<Usuario | null>;
  obtenerUsuarioPorId(idUsuario: number): Promise<Usuario | null>;
}
