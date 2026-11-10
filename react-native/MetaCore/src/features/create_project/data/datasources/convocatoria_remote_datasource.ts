import type { RobleApiClient } from "roble-client";
import type { RegistroRoble } from "../../domain/entities/types";
import { ConvocatoriaModel } from "../../models/convocatoria_model";
import { firstRow } from "./roble_utils";

export class ConvocatoriaRemoteDatasource {
  constructor(private readonly roble: RobleApiClient) {}

  async createConvocatoria(convocatoria: ConvocatoriaModel): Promise<RegistroRoble> {
    const filtro = { id_proyecto: convocatoria.idProyecto };
    const existente = await firstRow(this.roble, "convocatoria", filtro);
    if (existente) return existente;
    try {
      return await this.roble.create("convocatoria", convocatoria.toMap());
    } catch (error) {
      // Recuperar una creación que pudo llegar al servidor sin respuesta.
      const recuperada = await firstRow(this.roble, "convocatoria", filtro);
      if (recuperada) return recuperada;
      throw error;
    }
  }

  getConvocatoriaByProject(idProyecto: number): Promise<RegistroRoble | null> {
    return firstRow(this.roble, "convocatoria", { id_proyecto: idProyecto });
  }
}
