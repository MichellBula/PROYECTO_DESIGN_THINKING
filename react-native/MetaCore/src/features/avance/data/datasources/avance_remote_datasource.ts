import type { RobleApiClient } from "roble-client";

import type { RegistroAvance } from "../../domain/entities/avance";
import { AvanceModel } from "../../models/avance_model";

// No convertir null o "" en 0: se comporta como int.tryParse de Dart.
function convertirEntero(valor: unknown): number | null {
  if (valor === null || valor === undefined) return null;

  const texto = String(valor).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;

  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

export class AvanceRemoteDatasource {
  private static readonly MAX_INTENTOS_CREAR_AVANCE = 5;
  private static readonly MAX_AVANCES_POR_ETAPA = 5;
  private static readonly PORCENTAJE_POR_AVANCE = 20;

  // Inyectar el cliente: desde otra capa se entregará RobleClient.instance.
  constructor(private readonly roble: RobleApiClient) {}

  // ==========================================================
  // GENERAR SIGUIENTE ID
  // ==========================================================

  private async obtenerSiguienteId(): Promise<number> {
    const registros = (await this.roble.read("avance")) as RegistroAvance[];

    let mayorId = 0;
    for (const registro of registros) {
      const id = convertirEntero(registro["id_avance"]);
      if (id !== null && id > mayorId) mayorId = id;
    }
    return mayorId + 1;
  }

  // ==========================================================
  // BUSCAR AVANCE POR ID
  // ==========================================================

  private async buscarAvancePorId(
    idAvance: number
  ): Promise<RegistroAvance | null> {
    const registros = (await this.roble.read("avance", {
      id_avance: idAvance,
    })) as RegistroAvance[];

    return registros.length > 0 ? { ...registros[0] } : null;
  }

  // ==========================================================
  // COMPROBAR SI UN REGISTRO RECUPERADO COINCIDE
  // ==========================================================

  private avanceCoincide(
    existente: RegistroAvance,
    data: RegistroAvance
  ): boolean {
    return (
      String(existente["id_etapa"] ?? "") ===
        String(data["id_etapa"] ?? "") &&
      String(existente["comentario"] ?? "") ===
        String(data["comentario"] ?? "")
    );
  }

  // ==========================================================
  // OBTENER ID DEL PERFIL DE USUARIO AUTENTICADO
  // ==========================================================

  private async obtenerIdUsuarioAutenticado(): Promise<number> {
    if (!this.roble.isLoggedIn) {
      throw new Error("No hay una sesión autenticada en Roble.");
    }

    const user = await this.roble.currentUser();
    const userId = user?.userId;

    if (!userId) {
      throw new Error("No fue posible obtener el usuario autenticado.");
    }

    const usuarios = (await this.roble.read("usuario", {
      id_autenticador: userId,
    })) as RegistroAvance[];

    if (usuarios.length === 0) {
      throw new Error(
        "La cuenta autenticada no tiene un perfil registrado."
      );
    }

    const idUsuario = convertirEntero(usuarios[0]["id_usuario"]);
    if (idUsuario === null) {
      throw new Error(
        "El perfil del usuario no tiene un id_usuario válido."
      );
    }

    return idUsuario;
  }

  // ==========================================================
  // OBTENER ETAPA
  // ==========================================================

  private async obtenerEtapa(idEtapa: number): Promise<RegistroAvance> {
    const etapas = (await this.roble.read("etapa_proyecto", {
      id_etapa: idEtapa,
    })) as RegistroAvance[];

    if (etapas.length === 0) {
      throw new Error("No existe la etapa con id " + idEtapa + ".");
    }

    return { ...etapas[0] };
  }

  // ==========================================================
  // OBTENER PROYECTO DE LA ETAPA
  // ==========================================================

  private async obtenerProyectoDeEtapa(
    idEtapa: number
  ): Promise<RegistroAvance> {
    const etapa = await this.obtenerEtapa(idEtapa);
    const idProyecto = convertirEntero(etapa["id_proyecto"]);

    if (idProyecto === null) {
      throw new Error("La etapa no tiene un id_proyecto válido.");
    }

    const proyectos = (await this.roble.read("proyecto", {
      id_proyecto: idProyecto,
    })) as RegistroAvance[];

    if (proyectos.length === 0) {
      throw new Error("No existe el proyecto asociado a la etapa.");
    }

    return { ...proyectos[0] };
  }

  // ==========================================================
  // VALIDAR PERTENENCIA AL PROYECTO
  // ==========================================================

  private async verificarPertenenciaAlProyecto(
    idEtapa: number
  ): Promise<void> {
    const proyecto = await this.obtenerProyectoDeEtapa(idEtapa);
    const idProyecto = convertirEntero(proyecto["id_proyecto"]);
    const idCreador = convertirEntero(proyecto["id_creador"]);

    if (idProyecto === null) {
      throw new Error("El proyecto no tiene un id_proyecto válido.");
    }
    if (idCreador === null) {
      throw new Error("El proyecto no tiene un id_creador válido.");
    }

    const idUsuario = await this.obtenerIdUsuarioAutenticado();

    // El creador es parte del proyecto incluso si no está en integrantes.
    if (idUsuario === idCreador) return;

    const integrantes = await this.roble.read("integrantes", {
      id_usuario: idUsuario,
      id_proyecto: idProyecto,
    });

    if (integrantes.length === 0) {
      throw new Error(
        "Solo los usuarios que pertenecen al proyecto pueden registrar avances."
      );
    }
  }

  // ==========================================================
  // CONSULTAR AVANCES DE UNA ETAPA
  // ==========================================================

  async getAvancesByEtapa(idEtapa: number): Promise<RegistroAvance[]> {
    await this.obtenerEtapa(idEtapa);

    const registros = (await this.roble.read("avance", {
      id_etapa: idEtapa,
    })) as RegistroAvance[];

    const avances = registros.map((registro) => ({ ...registro }));
    avances.sort(
      (a, b) =>
        this.parsearFecha(a["fecha"]).getTime() -
        this.parsearFecha(b["fecha"]).getTime()
    );

    return avances;
  }

  // ==========================================================
  // CONSULTAR AVANCES DE UN PROYECTO
  // ==========================================================

  async getAvancesByProject(
    idProyecto: number
  ): Promise<RegistroAvance[]> {
    const proyectos = await this.roble.read("proyecto", {
      id_proyecto: idProyecto,
    });

    if (proyectos.length === 0) {
      throw new Error("No existe el proyecto con id " + idProyecto + ".");
    }

    const etapas = (await this.roble.read("etapa_proyecto", {
      id_proyecto: idProyecto,
    })) as RegistroAvance[];

    const resultado: RegistroAvance[] = [];

    for (const etapa of etapas) {
      const idEtapa = convertirEntero(etapa["id_etapa"]);
      if (idEtapa === null) continue;

      const avancesEtapa = await this.getAvancesByEtapa(idEtapa);
      resultado.push(...avancesEtapa);
    }

    return resultado;
  }

  // ==========================================================
  // CONSULTAR AVANCE POR ID
  // ==========================================================

  getAvanceById(idAvance: number): Promise<RegistroAvance | null> {
    return this.buscarAvancePorId(idAvance);
  }

  // ==========================================================
  // CALCULAR PORCENTAJE DE UNA ETAPA
  // ==========================================================

  async getPorcentajeByEtapa(idEtapa: number): Promise<number> {
    const avances = await this.getAvancesByEtapa(idEtapa);
    const porcentaje =
      avances.length * AvanceRemoteDatasource.PORCENTAJE_POR_AVANCE;

    return Math.min(100, Math.max(0, porcentaje));
  }

  // ==========================================================
  // CREAR AVANCE
  // ==========================================================

  async createAvance(avance: AvanceModel): Promise<RegistroAvance> {
    const comentario = avance.comentario.trim();

    if (comentario.length === 0) {
      throw new Error("El comentario del avance no puede estar vacío.");
    }
    if (!Number.isSafeInteger(avance.idEtapa) || avance.idEtapa <= 0) {
      throw new Error("El id_etapa debe ser válido.");
    }

    // El usuario debe ser creador o integrante del proyecto.
    await this.verificarPertenenciaAlProyecto(avance.idEtapa);

    const existentes = await this.getAvancesByEtapa(avance.idEtapa);
    if (
      existentes.length >= AvanceRemoteDatasource.MAX_AVANCES_POR_ETAPA
    ) {
      throw new Error(
        "Esta etapa ya tiene 5 avances y alcanzó el 100%. " +
        "No se pueden registrar más avances."
      );
    }

    const modelo = new AvanceModel(
      avance.idEtapa,
      comentario,
      avance.fecha
    );

    for (
      let intento = 1;
      intento <= AvanceRemoteDatasource.MAX_INTENTOS_CREAR_AVANCE;
      intento++
    ) {
      const idAvance = await this.obtenerSiguienteId();
      const payload = modelo.toMap({ idAvance });

      try {
        const resultado = (await this.roble.create(
          "avance",
          payload
        )) as RegistroAvance;

        console.log("[AVANCE] Avance creado correctamente.");
        console.log("[AVANCE] id_avance:", resultado["id_avance"]);
        console.log("[AVANCE] id_etapa:", resultado["id_etapa"]);
        console.log(
          "[AVANCE] Porcentaje de etapa después del registro:",
          (existentes.length + 1) * 20 + "%"
        );
        return { ...resultado };
      } catch (error) {
        console.error("[AVANCE] Error en intento " + intento, error);

        const existente = await this.buscarAvancePorId(idAvance);
        if (existente !== null) {
          if (this.avanceCoincide(existente, payload)) {
            console.log(
              "[AVANCE] El registro ya existía y coincide con la petición."
            );
            return existente;
          }
          // El ID ya fue asignado a otro avance. Intentar otro.
          continue;
        }
        throw error;
      }
    }

    throw new Error("No fue posible crear el avance.");
  }

  // ==========================================================
  // PARSEAR FECHA
  // ==========================================================

  private parsearFecha(valor: unknown): Date {
    if (valor instanceof Date) {
      return Number.isNaN(valor.getTime()) ? new Date(0) : valor;
    }

    const fecha =
      typeof valor === "number"
        ? new Date(valor)
        : new Date(String(valor ?? ""));

    return Number.isNaN(fecha.getTime()) ? new Date(0) : fecha;
  }
}
