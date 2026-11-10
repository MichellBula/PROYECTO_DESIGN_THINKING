import type { RobleApiClient } from "roble-client";
import type { RegistroRoble } from "../../domain/entities/types";
import { parseId } from "../../domain/entities/types";
import type { IntegranteCreator, UsuarioStatsUpdater } from "./create_project_ports";
import { firstRow, nextId } from "./roble_utils";

// Adaptadores independientes para probar el flujo sin haber migrado todavía
// la feature integrantes. Cuando esa feature exista, se pueden sustituir.
export class RobleIntegranteCreator implements IntegranteCreator {
  private readonly idFields = ["id_integrante", "id_integrantes", "id_integrante_proyecto"];
  private detectedField: string | null = null;

  constructor(private readonly roble: RobleApiClient) {}

  // Debe llamarse ANTES de crear el proyecto de prueba.
  async preflight(): Promise<void> {
    const existentes = await this.roble.read("integrantes");
    const ejemplo = existentes.find(row => this.idFields.some(field => row[field] !== undefined));
    if (!ejemplo) {
      throw new Error(
        "No pude determinar el campo de ID de 'integrantes' con los datos existentes. " +
        "Necesito el código de IntegranteRemoteDatasource para crear al líder con seguridad."
      );
    }
    this.detectedField = this.idFields.find(field => ejemplo[field] !== undefined) ?? null;
    if (!this.detectedField) throw new Error("No se encontró el ID de integrantes.");

    const rolLider = await firstRow(this.roble, "rol", { id_rol: 1 });
    if (!rolLider || String(rolLider.nombre_rol).toLowerCase() !== "líder de proyecto") {
      throw new Error("El rol id_rol=1 debe corresponder a 'Líder de proyecto'.");
    }
  }

  async createIntegranteSimple(params: {
    idUsuario: number; idProyecto: number; idRol: number;
  }): Promise<RegistroRoble> {
    if (!this.detectedField) throw new Error("Ejecuta preflight() antes de crear integrantes.");
    const filtro = { id_usuario: params.idUsuario, id_proyecto: params.idProyecto };
    const existente = await firstRow(this.roble, "integrantes", filtro);
    if (existente) return existente;

    for (let intento = 1; intento <= 5; intento++) {
      const id = await nextId(this.roble, "integrantes", this.detectedField);
      const payload = {
        [this.detectedField]: id,
        id_usuario: params.idUsuario,
        id_proyecto: params.idProyecto,
        id_rol: params.idRol,
      };
      try {
        return await this.roble.create("integrantes", payload);
      } catch (error) {
        const recuperado = await firstRow(this.roble, "integrantes", filtro);
        if (recuperado) return recuperado;
        const conflicto = await firstRow(this.roble, "integrantes", { [this.detectedField]: id });
        if (!conflicto || intento === 5) throw error;
      }
    }
    throw new Error("No fue posible crear al líder en integrantes.");
  }
}

// Versión autónoma del servicio de estadísticas que ya se trabajó en `core`.
// Se puede reemplazar por el servicio existente si cumple UsuarioStatsUpdater.
export class RobleUsuarioStatsUpdater implements UsuarioStatsUpdater {
  constructor(private readonly roble: RobleApiClient) {}

  async sincronizarUsuario(idUsuario: number): Promise<void> {
    const [creados, membresias, proyectos, usuarios] = await Promise.all([
      this.roble.read("proyecto", { id_creador: idUsuario }),
      this.roble.read("integrantes", { id_usuario: idUsuario }),
      this.roble.read("proyecto"),
      this.roble.read("usuario", { id_usuario: idUsuario }),
    ]);
    const ids = new Set<number>();
    for (const row of [...creados, ...membresias]) {
      try { ids.add(parseId(row.id_proyecto)); } catch { /* ignorar */ }
    }
    const calificaciones: number[] = [];
    for (const row of proyectos) {
      let id: number;
      try { id = parseId(row.id_proyecto); } catch { continue; }
      if (!ids.has(id) || row.calificacion == null) continue;
      const valor = Number(row.calificacion);
      if (Number.isFinite(valor)) calificaciones.push(valor);
    }
    const numeroProyectos = ids.size ? ids.size : null;
    const promedio = calificaciones.length
      ? Math.round((calificaciones.reduce((a, b) => a + b, 0) / calificaciones.length) * 100) / 100
      : null;
    if (!usuarios.length) throw new Error(`No se encontró usuario ${idUsuario}.`);
    const uuid = String(usuarios[0]._id ?? "").trim();
    if (!uuid) throw new Error(`El usuario ${idUsuario} no tiene _id de Roble.`);
    await this.roble.update("usuario", uuid, {
      numero_proyectos: numeroProyectos, calificacion_usuario: promedio,
    });
  }

  async sincronizarPorProyecto(idProyecto: number): Promise<void> {
    const proyecto = await firstRow(this.roble, "proyecto", { id_proyecto: idProyecto });
    if (!proyecto) throw new Error(`No existe proyecto ${idProyecto}.`);
    const ids = new Set<number>();
    try { ids.add(parseId(proyecto.id_creador)); } catch { /* ignorar */ }
    const integrantes = await this.roble.read("integrantes", { id_proyecto: idProyecto });
    for (const row of integrantes) {
      try { ids.add(parseId(row.id_usuario)); } catch { /* ignorar */ }
    }
    for (const idUsuario of ids) await this.sincronizarUsuario(idUsuario);
  }
}
