import type {
  Integrante,
  ParticipanteDetalle,
  RegistroIntegrante,
} from "../entities/integrante";

export interface IntegranteRepository {
  createIntegrante(integrante: Integrante): Promise<RegistroIntegrante>;
  createIntegranteSimple(params: {
    idUsuario: number;
    idProyecto: number;
    idRol: number;
  }): Promise<RegistroIntegrante>;
  getIntegrantesByProject(idProyecto: number): Promise<RegistroIntegrante[]>;
  getIntegranteByUserAndProject(params: {
    idUsuario: number;
    idProyecto: number;
  }): Promise<RegistroIntegrante | null>;
  getParticipantesByProject(idProyecto: number): Promise<ParticipanteDetalle[]>;
}
