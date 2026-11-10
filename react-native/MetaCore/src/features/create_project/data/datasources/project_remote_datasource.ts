import type { RobleApiClient } from "roble-client";
import type { RegistroRoble } from "../../domain/entities/types";
import { parseId } from "../../domain/entities/types";
import { ProjectModel } from "../../models/project_model";
import type { UsuarioStatsUpdater } from "./create_project_ports";
import { firstRow, nextId } from "./roble_utils";

export class ProjectRemoteDatasource {
  constructor(
    private readonly roble: RobleApiClient,
    private readonly statsService: UsuarioStatsUpdater
  ) {}

  private coincide(registro: RegistroRoble, payload: RegistroRoble): boolean {
    return ["nombre", "descripcion", "id_creador", "id_categoria",
      "id_tipo_proyecto", "objetivo", "requisitos", "num_integrantes",
      "docente_asesor", "estado"].every(
      campo => String(registro[campo]) === String(payload[campo])
    );
  }

  async createProject(project: ProjectModel): Promise<RegistroRoble> {
    const data = project.toMap();
    console.log("[PROJECT] Creando:", project.nombre);

    for (let intento = 1; intento <= 5; intento++) {
      const idProyecto = await nextId(this.roble, "proyecto", "id_proyecto");
      const payload = { id_proyecto: idProyecto, ...data };
      let creado: RegistroRoble;

      try {
        creado = await this.roble.create("proyecto", payload);
      } catch (error) {
        const existente = await firstRow(this.roble, "proyecto", { id_proyecto: idProyecto });
        if (existente && this.coincide(existente, payload)) {
          creado = existente; // Servidor creó la fila, pero no devolvió respuesta.
        } else if (existente && intento < 5) {
          continue; // Colisión de ID: volvemos a calcularlo.
        } else {
          throw error;
        }
      }

      // No reintentar la creación por un fallo posterior de estadísticas.
      await this.statsService.sincronizarUsuario(project.idCreador);
      return creado;
    }

    throw new Error("No fue posible crear el proyecto.");
  }

  async calificarProyecto(params: { idProyecto: number; calificacion: number }): Promise<RegistroRoble> {
    const { idProyecto, calificacion } = params;
    if (!Number.isFinite(calificacion) || calificacion < 1 || calificacion > 5) {
      throw new Error("La calificación debe estar entre 1.0 y 5.0.");
    }
    const proyecto = await firstRow(this.roble, "proyecto", { id_proyecto: idProyecto });
    if (!proyecto) throw new Error(`No existe el proyecto con id ${idProyecto}.`);

    const idCreador = parseId(proyecto.id_creador, "id_creador");
    const authUser = await this.roble.currentUser();
    const userId = authUser.userId;
    if (!userId) throw new Error("No fue posible obtener el usuario autenticado.");
    const perfil = await firstRow(this.roble, "usuario", { id_autenticador: userId });
    if (!perfil) throw new Error("La cuenta autenticada no tiene un perfil registrado.");
    if (parseId(perfil.id_usuario, "id_usuario") !== idCreador) {
      throw new Error("Solo el creador del proyecto puede calificarlo.");
    }

    const robleId = String(proyecto._id ?? "").trim();
    if (!robleId) throw new Error("El proyecto no tiene un _id válido de Roble.");
    const resultado = await this.roble.update("proyecto", robleId, { calificacion });
    await this.statsService.sincronizarPorProyecto(idProyecto);
    return resultado;
  }
}
