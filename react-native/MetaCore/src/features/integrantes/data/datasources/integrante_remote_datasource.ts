import type { RobleApiClient } from "roble-client";

import type {
  ParticipanteDetalle,
  RegistroIntegrante,
} from "../../domain/entities/integrante";
import { IntegranteModel } from "../../models/integrante_model";

// Puerto de dependencia: se implementa con core/services/usuario_stats_service.ts.
export interface UsuarioStatsServicePort {
  sincronizarUsuario(idUsuario: number): Promise<void>;
}

function convertirEntero(valor: unknown): number | null {
  if (valor === undefined || valor === null) return null;
  const texto = String(valor).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;
  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

export class IntegranteRemoteDatasource {
  private static readonly MAX_INTENTOS_CREAR = 5;

  // Ambas dependencias se proporcionan al configurar el módulo, no al renderizar.
  constructor(
    private readonly roble: RobleApiClient,
    private readonly statsService: UsuarioStatsServicePort
  ) {}

  private async obtenerSiguienteId(): Promise<number> {
    const integrantes = await this.roble.read("integrantes");
    let mayorId = 0;

    for (const integrante of integrantes) {
      const id = convertirEntero(integrante["id_usuario_integrante"]);
      if (id !== null && id > mayorId) mayorId = id;
    }

    return mayorId + 1;
  }

  private async idExiste(idUsuarioIntegrante: number): Promise<boolean> {
    const integrantes = await this.roble.read("integrantes", {
      id_usuario_integrante: idUsuarioIntegrante,
    });
    return integrantes.length > 0;
  }

  private async buscarIntegranteExistente(params: {
    idUsuario: number;
    idProyecto: number;
  }): Promise<RegistroIntegrante | null> {
    const integrantes = await this.roble.read("integrantes", {
      id_usuario: params.idUsuario,
      id_proyecto: params.idProyecto,
    });

    return integrantes.length > 0 ? { ...integrantes[0] } : null;
  }

  private async sincronizarEstadisticasSinInterrumpir(
    idUsuario: number
  ): Promise<void> {
    try {
      await this.statsService.sincronizarUsuario(idUsuario);
      console.info("[INTEGRANTE] Estadísticas del usuario actualizadas.");
    } catch (error) {
      // El integrante ya fue creado: no convertir la falla de estadísticas
      // en un nuevo intento de crear el mismo registro.
      console.warn(
        "[INTEGRANTE] Integrante creado; no se pudieron sincronizar estadísticas:",
        error
      );
    }
  }

  private async crearConReintentos(
    integrante: IntegranteModel
  ): Promise<RegistroIntegrante> {
    for (
      let intento = 1;
      intento <= IntegranteRemoteDatasource.MAX_INTENTOS_CREAR;
      intento++
    ) {
      const idUsuarioIntegrante = await this.obtenerSiguienteId();

      try {
        const resultado = await this.roble.create(
          "integrantes",
          integrante.toMap({ idUsuarioIntegrante })
        );

        const creado = { ...resultado };
        console.info(
          `[INTEGRANTE] Integrante creado. Usuario=${integrante.idUsuario}; proyecto=${integrante.idProyecto}.`
        );

        await this.sincronizarEstadisticasSinInterrumpir(integrante.idUsuario);
        return creado;
      } catch (error) {
        // Como en Dart, reintentar solamente cuando ese ID quedó ocupado.
        const idFueOcupado = await this.idExiste(idUsuarioIntegrante);

        if (
          !idFueOcupado ||
          intento === IntegranteRemoteDatasource.MAX_INTENTOS_CREAR
        ) {
          throw error;
        }
      }
    }

    throw new Error("No fue posible crear el integrante.");
  }

  async createIntegrante(integrante: IntegranteModel): Promise<RegistroIntegrante> {
    const existente = await this.buscarIntegranteExistente({
      idUsuario: integrante.idUsuario,
      idProyecto: integrante.idProyecto,
    });

    if (existente !== null) {
      throw new Error("El usuario ya es integrante de este proyecto.");
    }

    return this.crearConReintentos(integrante);
  }

  // Ruta alternativa de creación que existe en el código Dart original.
  // No comprueba duplicados: úsala únicamente si ese comportamiento es deseado.
  createIntegranteSimple(params: {
    idUsuario: number;
    idProyecto: number;
    idRol: number;
  }): Promise<RegistroIntegrante> {
    return this.crearConReintentos(
      new IntegranteModel(params.idUsuario, params.idProyecto, params.idRol)
    );
  }

  async getIntegrantesByProject(
    idProyecto: number
  ): Promise<RegistroIntegrante[]> {
    const integrantes = await this.roble.read("integrantes", {
      id_proyecto: idProyecto,
    });

    return integrantes.map((item) => ({ ...item }));
  }

  getIntegranteByUserAndProject(params: {
    idUsuario: number;
    idProyecto: number;
  }): Promise<RegistroIntegrante | null> {
    return this.buscarIntegranteExistente(params);
  }

  private async obtenerNombreUsuario(idUsuario: number | null): Promise<string> {
    if (idUsuario === null) return "";

    const usuarios = await this.roble.read("usuario", {
      id_usuario: idUsuario,
    });

    if (usuarios.length === 0) return "Desconocido";
    return String(usuarios[0]["nombre_usuario"] ?? "Desconocido");
  }

  private async obtenerNombreRol(idRol: number | null): Promise<string> {
    if (idRol === null) return "";

    const roles = await this.roble.read("rol", { id_rol: idRol });

    if (roles.length === 0) return "Sin rol";
    return String(roles[0]["nombre_rol"] ?? "Sin rol");
  }

  async getParticipantesByProject(
    idProyecto: number
  ): Promise<ParticipanteDetalle[]> {
    const integrantes = await this.getIntegrantesByProject(idProyecto);

    return Promise.all(
      integrantes.map(async (integrante): Promise<ParticipanteDetalle> => {
        const idUsuario = convertirEntero(integrante["id_usuario"]);
        const idRol = convertirEntero(integrante["id_rol"]);

        const [nombreUsuario, nombreRol] = await Promise.all([
          this.obtenerNombreUsuario(idUsuario),
          this.obtenerNombreRol(idRol),
        ]);

        return { nombreUsuario, nombreRol };
      })
    );
  }
}
