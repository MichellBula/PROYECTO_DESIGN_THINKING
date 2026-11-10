import type {
  Publicacion,
  RegistroPublicacion,
} from "../../domain/entities/publicacion";
import type { PublicacionRepository } from "../../domain/repositories/publicacion_repository";
import { PublicacionModel } from "../../models/publicacion_model";
import { PublicacionRemoteDatasource } from "../datasources/publicacion_remote_datasource";

export class PublicacionRepositoryImpl implements PublicacionRepository {
  constructor(private readonly datasource: PublicacionRemoteDatasource) {}

  createPublicacion(publicacion: Publicacion): Promise<RegistroPublicacion> {
    return this.datasource.createPublicacion(
      PublicacionModel.fromEntity(publicacion)
    );
  }

  getPublicacionesByProject(idProyecto: number): Promise<RegistroPublicacion[]> {
    return this.datasource.getPublicacionesByProject(idProyecto);
  }

  getPublicacionById(idPublicacion: number): Promise<RegistroPublicacion | null> {
    return this.datasource.getPublicacionById(idPublicacion);
  }

  getTodasLasPublicaciones(): Promise<RegistroPublicacion[]> {
    return this.datasource.getTodasLasPublicaciones();
  }
}
