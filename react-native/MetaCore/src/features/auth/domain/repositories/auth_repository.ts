import type { AuthUser } from "../entities/auth_user";

export interface AuthRepository {
  login(params: {
    email: string;
    password: string;
  }): Promise<AuthUser>;

  registrar(params: {
    email: string;
    password: string;
    name: string;
  }): Promise<void>;

  obtenerUsuarioActual(): Promise<AuthUser | null>;

  restaurarSesion(): Promise<void>;

  logout(): Promise<void>;

  readonly estaAutenticado: boolean;
}