import type {
  Publicacion,
  RegistroPublicacion,
} from "../entities/publicacion";

// Contrato del dominio; la infraestructura lo implementa en `data`.
export interface PublicacionRepository {
  createPublicacion(publicacion: Publicacion): Promise<RegistroPublicacion>;
  getPublicacionesByProject(idProyecto: number): Promise<RegistroPublicacion[]>;
  getPublicacionById(idPublicacion: number): Promise<RegistroPublicacion | null>;
  getTodasLasPublicaciones(): Promise<RegistroPublicacion[]>;
}
