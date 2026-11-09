// Contratos mínimos para los datasources de otras features.
// Evitan importar implementaciones que todavía no se han migrado de Flutter.
export type RegistroRoble = Record<string, unknown>;

export interface ConvocatoriaReader {
  getConvocatoriaByProject(
    idProyecto: number
  ): Promise<RegistroRoble | null>;
}

export interface ProjectRolesReader {
  getRolesByProject(idProyecto: number): Promise<RegistroRoble[]>;
}

export interface ProjectSkillsReader {
  getSkillsByProject(idProyecto: number): Promise<RegistroRoble[]>;
}

export interface UsuarioReader {
  obtenerUsuarioPorId(
    idUsuario: number
  ): Promise<{ nombreUsuario: string } | null>;
}
