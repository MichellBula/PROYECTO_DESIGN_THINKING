import type { RobleApiClient } from "roble-client";

import type { RegistroEtapa } from "../../domain/entities/etapa";
import { EtapaModel } from "../../models/etapa_model";

function toInt(value: unknown): number | null {
  if (value === null || value === undefined) return null;
  const texto = String(value).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;
  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

// El datasource recibe el RobleApiClient de core por inyección de dependencias.
export class EtapaRemoteDatasource {
  private static readonly MAX_INTENTOS = 5;

  constructor(private readonly roble: RobleApiClient) {}

  private async obtenerSiguienteId(): Promise<number> {
    const etapas = await this.roble.read("etapa_proyecto");
    let mayorId = 0;

    for (const etapa of etapas) {
      const id = toInt(etapa["id_etapa"]);
      if (id !== null && id > mayorId) mayorId = id;
    }

    return mayorId + 1;
  }

  private async buscarEtapaPorId(idEtapa: number): Promise<RegistroEtapa | null> {
    const etapas = await this.roble.read("etapa_proyecto", {
      id_etapa: idEtapa,
    });
    return etapas.length ? { ...etapas[0] } : null;
  }

  private etapaCoincide(etapa: RegistroEtapa, data: RegistroEtapa): boolean {
    return ["id_proyecto", "nombre_etapa", "orden"].every(
      (campo) => String(etapa[campo] ?? "") === String(data[campo] ?? "")
    );
  }

  private async obtenerIdUsuarioAutenticado(): Promise<number> {
    const user = await this.roble.currentUser();
    const userId = user?.userId?.toString();

    if (!userId) {
      throw new Error("No fue posible obtener el usuario autenticado.");
    }

    const usuarios = await this.roble.read("usuario", {
      id_autenticador: userId,
    });

    if (!usuarios.length) {
      throw new Error("La cuenta autenticada no tiene un perfil registrado.");
    }

    const idUsuario = toInt(usuarios[0]["id_usuario"]);
    if (idUsuario === null) {
      throw new Error("El perfil no tiene un id_usuario válido.");
    }

    return idUsuario;
  }

  private async obtenerProyecto(idProyecto: number): Promise<RegistroEtapa> {
    const proyectos = await this.roble.read("proyecto", {
      id_proyecto: idProyecto,
    });

    if (!proyectos.length) {
      throw new Error(`No existe el proyecto con id ${idProyecto}.`);
    }

    return { ...proyectos[0] };
  }

  private async verificarCreador(idProyecto: number): Promise<void> {
    const proyecto = await this.obtenerProyecto(idProyecto);
    const idCreador = toInt(proyecto["id_creador"]);

    if (idCreador === null) {
      throw new Error("El proyecto no tiene un id_creador válido.");
    }

    const idUsuario = await this.obtenerIdUsuarioAutenticado();
    if (idUsuario !== idCreador) {
      throw new Error("Solo el creador del proyecto puede crear sus etapas.");
    }
  }

  private async validarNombreYOrden(etapa: EtapaModel): Promise<void> {
    const etapas = await this.roble.read("etapa_proyecto", {
      id_proyecto: etapa.idProyecto,
    });

    const nombreBuscado = etapa.nombreEtapa.trim().toLowerCase();

    for (const existente of etapas) {
      const nombreExistente = String(existente["nombre_etapa"] ?? "")
        .trim()
        .toLowerCase();
      const ordenExistente = toInt(existente["orden"]);

      if (nombreExistente === nombreBuscado) {
        throw new Error("Ya existe una etapa con ese nombre en este proyecto.");
      }

      if (ordenExistente === etapa.orden) {
        throw new Error("Ya existe una etapa con ese orden en este proyecto.");
      }
    }
  }

  async createEtapa(etapa: EtapaModel): Promise<RegistroEtapa> {
    const nombre = etapa.nombreEtapa.trim();

    if (!nombre) {
      throw new Error("El nombre de la etapa no puede estar vacío.");
    }

    if (!Number.isSafeInteger(etapa.orden) || etapa.orden < 1) {
      throw new Error("El orden de la etapa debe ser mayor que cero.");
    }

    await this.verificarCreador(etapa.idProyecto);
    await this.validarNombreYOrden(etapa);

    const modelo = new EtapaModel(etapa.idProyecto, nombre, etapa.orden);

    for (let intento = 1; intento <= EtapaRemoteDatasource.MAX_INTENTOS; intento++) {
      const idEtapa = await this.obtenerSiguienteId();
      const payload = modelo.toMap({ idEtapa });

      try {
        const resultado = await this.roble.create("etapa_proyecto", payload);
        console.log("[ETAPA] Etapa creada:", resultado);
        return { ...resultado };
      } catch (error) {
        console.error(`[ETAPA] Error en intento ${intento}:`, error);

        // El servidor puede haber insertado la fila aunque la respuesta fallara.
        const existente = await this.buscarEtapaPorId(idEtapa);
        if (existente) {
          if (this.etapaCoincide(existente, payload)) {
            return existente;
          }

          // Si el ID lo ocupó otra etapa, recalculamos el siguiente.
          if (intento < EtapaRemoteDatasource.MAX_INTENTOS) continue;
        }

        throw error;
      }
    }

    throw new Error("No fue posible crear la etapa.");
  }

  getEtapaById(idEtapa: number): Promise<RegistroEtapa | null> {
    return this.buscarEtapaPorId(idEtapa);
  }

  async getEtapasByProject(idProyecto: number): Promise<RegistroEtapa[]> {
    await this.obtenerProyecto(idProyecto);

    const registros = await this.roble.read("etapa_proyecto", {
      id_proyecto: idProyecto,
    });

    const etapas: RegistroEtapa[] = registros.map((item) => ({ ...item }));

    etapas.sort((a, b) => {
      const ordenA = toInt(a["orden"]) ?? 0;
      const ordenB = toInt(b["orden"]) ?? 0;
      if (ordenA !== ordenB) return ordenA - ordenB;

      const idA = toInt(a["id_etapa"]) ?? 0;
      const idB = toInt(b["id_etapa"]) ?? 0;
      return idA - idB;
    });

    return etapas;
  }
}
