import type { RobleApiClient } from "roble-client";

import type { RegistroSolicitud } from "../../domain/entities/solicitud";
import { SolicitudModel } from "../../models/solicitud_model";

function convertirEntero(valor: unknown): number | null {
  if (valor === null || valor === undefined) return null;
  const texto = String(valor).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;
  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

function texto(valor: unknown, fallback = "No disponible"): string {
  const resultado = valor == null ? "" : String(valor).trim();
  return resultado || fallback;
}

export class SolicitudRemoteDatasource {
  private static readonly MAX_INTENTOS_CREAR = 5;

  constructor(private readonly roble: RobleApiClient) {}

  private async obtenerSiguienteId(): Promise<number> {
    const solicitudes = await this.roble.read("solicitudes");
    let mayorId = 0;

    for (const solicitud of solicitudes) {
      const id = convertirEntero(solicitud["id_solicitud"]);
      if (id !== null && id > mayorId) mayorId = id;
    }

    return mayorId + 1;
  }

  private async idExiste(idSolicitud: number): Promise<boolean> {
    const solicitudes = await this.roble.read("solicitudes", {
      id_solicitud: idSolicitud,
    });
    return solicitudes.length > 0;
  }

  private async buscarSolicitudesExistentes(params: {
    idUsuario: number;
    idProyecto: number;
  }): Promise<RegistroSolicitud[]> {
    const solicitudes = await this.roble.read("solicitudes", {
      id_usuario: params.idUsuario,
      id_proyecto: params.idProyecto,
    });
    return solicitudes.map((item) => ({ ...item }));
  }

  async tieneSolicitudEnProyecto(params: {
    idUsuario: number;
    idProyecto: number;
  }): Promise<boolean> {
    const solicitudes = await this.buscarSolicitudesExistentes(params);
    return solicitudes.length > 0;
  }

  async createSolicitud(solicitud: SolicitudModel): Promise<RegistroSolicitud> {
    if (solicitud.estado !== "pendiente") {
      throw new Error("Una solicitud nueva debe comenzar en estado pendiente.");
    }

    if (Number.isNaN(solicitud.fechaEnviada.getTime())) {
      throw new Error("La fecha de envío de la solicitud no es válida.");
    }

    if (
      solicitud.fechaRespuesta !== null &&
      Number.isNaN(solicitud.fechaRespuesta.getTime())
    ) {
      throw new Error("La fecha de respuesta de la solicitud no es válida.");
    }

    const idUsuarioAutenticado = await this.getIdUsuarioAutenticado();
    if (solicitud.idUsuario !== idUsuarioAutenticado) {
      throw new Error(
        "El usuario de la solicitud no coincide con el usuario autenticado."
      );
    }

    const idCreador = await this.getIdCreadorDelProyecto(
      solicitud.idProyecto
    );

    if (idCreador === idUsuarioAutenticado) {
      throw new Error("No puedes postularte a un proyecto que tú mismo creaste.");
    }

    const params = {
      idUsuario: idUsuarioAutenticado,
      idProyecto: solicitud.idProyecto,
    };
    const existentes = await this.buscarSolicitudesExistentes(params);

    if (existentes.length > 0) {
      throw new Error(
        "Ya te postulaste a este proyecto. No puedes enviar otra solicitud al mismo proyecto."
      );
    }

    for (
      let intento = 1;
      intento <= SolicitudRemoteDatasource.MAX_INTENTOS_CREAR;
      intento++
    ) {
      const idSolicitud = await this.obtenerSiguienteId();

      try {
        const resultado = await this.roble.create(
          "solicitudes",
          solicitud.toMap({ idSolicitud })
        );
        return { ...resultado };
      } catch (error) {
        // Protege frente a una inserción que sí se completó pero cuya
        // respuesta se perdió por un fallo de conexión.
        const existentesTrasError =
          await this.buscarSolicitudesExistentes(params);
        const solicitudInsertada = existentesTrasError.find(
          (item) => convertirEntero(item["id_solicitud"]) === idSolicitud
        );
        if (solicitudInsertada) return solicitudInsertada;

        if (existentesTrasError.length > 0) {
          throw new Error("Ya existe una solicitud de este usuario al proyecto.");
        }

        const idFueOcupado = await this.idExiste(idSolicitud);
        if (
          !idFueOcupado ||
          intento === SolicitudRemoteDatasource.MAX_INTENTOS_CREAR
        ) {
          throw error;
        }
      }
    }

    throw new Error("No fue posible crear la solicitud.");
  }

  private async agregarDatosDePresentacion(
    solicitud: RegistroSolicitud
  ): Promise<RegistroSolicitud> {
    const idProyecto = convertirEntero(solicitud["id_proyecto"]);
    const idUsuario = convertirEntero(solicitud["id_usuario"]);
    const idProyectoRol = convertirEntero(solicitud["id_proyecto_rol"]);

    let proyecto: RegistroSolicitud | null = null;
    let usuario: RegistroSolicitud | null = null;
    let proyectoRol: RegistroSolicitud | null = null;
    let rol: RegistroSolicitud | null = null;

    if (idProyecto !== null) {
      const registros = await this.roble.read("proyecto", {
        id_proyecto: idProyecto,
      });
      if (registros.length) proyecto = { ...registros[0] };
    }

    if (idUsuario !== null) {
      const registros = await this.roble.read("usuario", {
        id_usuario: idUsuario,
      });
      if (registros.length) usuario = { ...registros[0] };
    }

    if (idProyectoRol !== null) {
      const registros = await this.roble.read("proyecto_roles", {
        id_proyecto_rol: idProyectoRol,
      });
      if (registros.length) proyectoRol = { ...registros[0] };
    }

    const idRol = convertirEntero(proyectoRol?.["id_rol"]);
    if (idRol !== null) {
      const registros = await this.roble.read("rol", { id_rol: idRol });
      if (registros.length) rol = { ...registros[0] };
    }

    const semestreRaw = texto(usuario?.["semestre"], "");
    const semestre = semestreRaw ? `${semestreRaw} semestre` : "No disponible";

    return {
      ...solicitud,
      nombre_proyecto: texto(proyecto?.["nombre"], "Proyecto no disponible"),
      nombre_usuario: texto(usuario?.["nombre_usuario"], "Usuario no disponible"),
      correo_institucional: texto(usuario?.["correo_institucional"], ""),
      carrera: texto(usuario?.["carrera"]),
      semestre_presentacion: semestre,
      nombre_rol: texto(rol?.["nombre_rol"], "Rol no disponible"),
    };
  }

  async getMisSolicitudes(idUsuario: number): Promise<RegistroSolicitud[]> {
    const solicitudes = await this.roble.read("solicitudes", {
      id_usuario: idUsuario,
    });

    const resultado: RegistroSolicitud[] = [];
    for (const solicitud of solicitudes) {
      resultado.push(await this.agregarDatosDePresentacion({ ...solicitud }));
    }
    return resultado;
  }

  async getSolicitudesPendientesDeMisProyectos(
    idUsuario: number
  ): Promise<RegistroSolicitud[]> {
    const proyectos = await this.roble.read("proyecto", {
      id_creador: idUsuario,
    });

    const resultado: RegistroSolicitud[] = [];
    for (const proyecto of proyectos) {
      const idProyecto = convertirEntero(proyecto["id_proyecto"]);
      if (idProyecto === null) continue;

      const solicitudes = await this.roble.read("solicitudes", {
        id_proyecto: idProyecto,
        estado: "pendiente",
      });

      for (const solicitud of solicitudes) {
        resultado.push(await this.agregarDatosDePresentacion({ ...solicitud }));
      }
    }
    return resultado;
  }

  async getSolicitudById(idSolicitud: number): Promise<RegistroSolicitud | null> {
    const solicitudes = await this.roble.read("solicitudes", {
      id_solicitud: idSolicitud,
    });
    return solicitudes.length > 0 ? { ...solicitudes[0] } : null;
  }

  async getIdUsuarioAutenticado(): Promise<number> {
    const usuarioAuth = await this.roble.currentUser();
    const userId = usuarioAuth?.userId?.toString();

    if (!userId) {
      throw new Error("No fue posible obtener el usuario autenticado.");
    }

    const usuarios = await this.roble.read("usuario", {
      id_autenticador: userId,
    });

    if (usuarios.length === 0) {
      throw new Error(
        "No existe un perfil de usuario asociado a la cuenta autenticada."
      );
    }

    const idUsuario = convertirEntero(usuarios[0]["id_usuario"]);
    if (idUsuario === null) {
      throw new Error("El perfil no tiene un id_usuario válido.");
    }
    return idUsuario;
  }

  async getIdCreadorDelProyecto(idProyecto: number): Promise<number> {
    const proyectos = await this.roble.read("proyecto", {
      id_proyecto: idProyecto,
    });

    if (proyectos.length === 0) {
      throw new Error(`No existe el proyecto con id ${idProyecto}.`);
    }

    const idCreador = convertirEntero(proyectos[0]["id_creador"]);
    if (idCreador === null) {
      throw new Error("El proyecto no tiene un id_creador válido.");
    }
    return idCreador;
  }

  async getProyectoRolById(idProyectoRol: number): Promise<RegistroSolicitud | null> {
    const registros = await this.roble.read("proyecto_roles", {
      id_proyecto_rol: idProyectoRol,
    });
    return registros.length > 0 ? { ...registros[0] } : null;
  }

  async responderSolicitud(params: {
    idSolicitud: number;
    nuevoEstado: string;
  }): Promise<RegistroSolicitud> {
    const estado = params.nuevoEstado.trim().toLowerCase();
    if (estado !== "aceptado" && estado !== "rechazado") {
      throw new Error("El estado debe ser aceptado o rechazado.");
    }

    const solicitud = await this.getSolicitudById(params.idSolicitud);
    if (!solicitud) {
      throw new Error(`No existe la solicitud con id ${params.idSolicitud}.`);
    }

    const estadoActual = String(solicitud["estado"] ?? "").trim().toLowerCase();
    if (estadoActual !== "pendiente") {
      throw new Error("Solo se pueden responder solicitudes pendientes.");
    }

    const idProyecto = convertirEntero(solicitud["id_proyecto"]);
    if (idProyecto === null) {
      throw new Error("La solicitud no tiene un id_proyecto válido.");
    }

    const idUsuarioAutenticado = await this.getIdUsuarioAutenticado();
    const idCreador = await this.getIdCreadorDelProyecto(idProyecto);
    if (idUsuarioAutenticado !== idCreador) {
      throw new Error("Solo el creador del proyecto puede responder esta solicitud.");
    }

    const idInternoRoble = solicitud["_id"]?.toString();
    if (!idInternoRoble) {
      throw new Error("La solicitud no tiene un _id válido de Roble.");
    }

    const resultado = await this.roble.update("solicitudes", idInternoRoble, {
      estado,
      fecha_respuesta: new Date().toISOString(),
    });
    return { ...resultado };
  }
}
