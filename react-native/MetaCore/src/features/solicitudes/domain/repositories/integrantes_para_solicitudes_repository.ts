// Puerto mínimo: permite usar `IntegranteRepositoryImpl` sin importar una
// implementación concreta de otra feature en el dominio de solicitudes.
export interface DatosIntegrante {
  idUsuario: number;
  idProyecto: number;
  idRol: number;
}

export interface IntegrantesParaSolicitudesRepository {
  getIntegrantesByProject(idProyecto: number): Promise<Record<string, unknown>[]>;
  getIntegranteByUserAndProject(params: {
    idUsuario: number;
    idProyecto: number;
  }): Promise<Record<string, unknown> | null>;
  createIntegrante(integrante: DatosIntegrante): Promise<Record<string, unknown>>;
}
