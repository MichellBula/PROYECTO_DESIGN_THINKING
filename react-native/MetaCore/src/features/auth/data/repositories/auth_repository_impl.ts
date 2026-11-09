import type { AuthUser } from "../../domain/entities/auth_user";
import type { AuthRepository } from "../../domain/repositories/auth_repository";
import type { AuthRemoteDataSource } from "../datasources/auth_remote_data_source";

export class AuthRepositoryImpl implements AuthRepository {
  constructor(
    private readonly remoteDataSource: AuthRemoteDataSource
  ) {}

  // Iniciar sesión
  login(params: {
    email: string;
    password: string;
  }): Promise<AuthUser> {
    return this.remoteDataSource.login(params);
  }

  // Registrar usuario
  registrar(params: {
    email: string;
    password: string;
    name: string;
  }): Promise<void> {
    return this.remoteDataSource.registrar(params);
  }

  // Obtener usuario autenticado
  obtenerUsuarioActual(): Promise<AuthUser | null> {
    return this.remoteDataSource.obtenerUsuarioActual();
  }

  // Restaurar sesión
  restaurarSesion(): Promise<void> {
    return this.remoteDataSource.restaurarSesion();
  }

  // Cerrar sesión
  logout(): Promise<void> {
    return this.remoteDataSource.logout();
  }

  // Consultar estado de autenticación
  get estaAutenticado(): boolean {
    return this.remoteDataSource.estaAutenticado;
  }
}