
import type { RobleApiClient } from "roble-client";

import { AuthUser } from "../../domain/entities/auth_user";
import type { AuthRemoteDataSource } from "./auth_remote_data_source";

export class AuthRemoteDataSourceImpl
  implements AuthRemoteDataSource {

  constructor(
    private readonly roble: RobleApiClient
  ) {}

  // Convertir el usuario de Roble a nuestra entidad AuthUser.
  private mapearUsuario(user: {
    userId: string;
    email: string;
    name: string;
  }): AuthUser {
    return new AuthUser(
      user.userId,
      user.email,
      user.name
    );
  }

  // ======================================================
  // LOGIN
  // ======================================================

  async login(params: {
    email: string;
    password: string;
  }): Promise<AuthUser> {
    const user = await this.roble.login({
      email: params.email,
      password: params.password,
    });

    return this.mapearUsuario(user);
  }

  // ======================================================
  // REGISTRO
  // ======================================================

  async registrar(params: {
    email: string;
    password: string;
    name: string;
  }): Promise<void> {
    await this.roble.register({
      email: params.email,
      password: params.password,
      name: params.name,
    });
  }

  // ======================================================
  // OBTENER USUARIO ACTUAL
  // ======================================================

  async obtenerUsuarioActual(): Promise<AuthUser | null> {
    if (!this.roble.isLoggedIn) {
      return null;
    }

    const user = await this.roble.currentUser();

    if (!user) {
      return null;
    }

    return this.mapearUsuario(user);
  }

  // ======================================================
  // RESTAURAR SESIÓN
  // ======================================================

  async restaurarSesion(): Promise<void> {
    await this.roble.restoreSession();
  }

  // ======================================================
  // LOGOUT
  // ======================================================

  async logout(): Promise<void> {
    await this.roble.logout();
  }

  // ======================================================
  // ESTADO DE AUTENTICACIÓN
  // ======================================================

  get estaAutenticado(): boolean {
    return this.roble.isLoggedIn;
  }
}
