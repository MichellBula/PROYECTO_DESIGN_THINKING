import type { RegistroRoble } from "../../domain/entities/types";

// Puertos para los módulos que no están dentro del ZIP (integrantes / core).
export interface IntegranteCreator {
  createIntegranteSimple(params: {
    idUsuario: number; idProyecto: number; idRol: number;
  }): Promise<RegistroRoble>;
}

export interface UsuarioStatsUpdater {
  sincronizarUsuario(idUsuario: number): Promise<void>;
  sincronizarPorProyecto(idProyecto: number): Promise<void>;
}
