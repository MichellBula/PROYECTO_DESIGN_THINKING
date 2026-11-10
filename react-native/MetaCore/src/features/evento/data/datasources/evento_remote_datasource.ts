import type { RobleApiClient } from "roble-client";

import type { RegistroEvento } from "../../domain/entities/evento";
import { EventoModel } from "../../models/evento_model";

function convertirEntero(valor: unknown): number | null {
  if (valor === null || valor === undefined) return null;
  const texto = String(valor).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;
  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

// El cliente de Roble se recibe por inyección desde `core/roble`.
export class EventoRemoteDatasource {
  private static readonly MAX_INTENTOS_CREAR_EVENTO = 5;

  constructor(private readonly roble: RobleApiClient) {}

  private async obtenerSiguienteId(): Promise<number> {
    const eventos = await this.roble.read("evento");
    let mayorId = 0;

    for (const evento of eventos) {
      const id = convertirEntero(evento["id_evento"]);
      if (id !== null && id > mayorId) mayorId = id;
    }

    return mayorId + 1;
  }

  private async idExiste(idEvento: number): Promise<boolean> {
    const eventos = await this.roble.read("evento", { id_evento: idEvento });
    return eventos.length > 0;
  }

  private async obtenerIdUsuarioAutenticado(): Promise<number> {
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
      throw new Error("El perfil de usuario no tiene un id_usuario válido.");
    }

    return idUsuario;
  }

  private async obtenerIdCreadorDelProyecto(
    idProyecto: number
  ): Promise<number> {
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

  async createEvento(evento: EventoModel): Promise<RegistroEvento> {
    if (!evento.nombre.trim()) {
      throw new Error("El nombre del evento no puede estar vacío.");
    }

    if (!evento.tipoEvento.trim()) {
      throw new Error("El tipo de evento no puede estar vacío.");
    }

    if (!evento.descripcion.trim()) {
      throw new Error("La descripción del evento no puede estar vacía.");
    }

    if (
      Number.isNaN(evento.fechaInicio.getTime()) ||
      Number.isNaN(evento.fechaFinal.getTime())
    ) {
      throw new Error("Las fechas del evento deben ser válidas.");
    }

    if (evento.fechaFinal.getTime() < evento.fechaInicio.getTime()) {
      throw new Error(
        "La fecha final no puede ser anterior a la fecha de inicio."
      );
    }

    const idCreador = await this.obtenerIdCreadorDelProyecto(
      evento.idProyecto
    );
    const idUsuarioAutenticado = await this.obtenerIdUsuarioAutenticado();

    if (idUsuarioAutenticado !== idCreador) {
      throw new Error("Solo el creador del proyecto puede crear eventos.");
    }

    for (
      let intento = 1;
      intento <= EventoRemoteDatasource.MAX_INTENTOS_CREAR_EVENTO;
      intento++
    ) {
      const idEvento = await this.obtenerSiguienteId();

      try {
        const resultado = await this.roble.create(
          "evento",
          evento.toMap({ idEvento })
        );
        return { ...resultado };
      } catch (error) {
        // Conserva el reintento de Dart solo si otra fila ocupó ese ID.
        const idFueOcupado = await this.idExiste(idEvento);
        if (
          !idFueOcupado ||
          intento === EventoRemoteDatasource.MAX_INTENTOS_CREAR_EVENTO
        ) {
          throw error;
        }
      }
    }

    throw new Error("No fue posible crear el evento.");
  }

  async getEventosByProject(idProyecto: number): Promise<RegistroEvento[]> {
    const proyectos = await this.roble.read("proyecto", {
      id_proyecto: idProyecto,
    });

    if (proyectos.length === 0) {
      throw new Error(`No existe el proyecto con id ${idProyecto}.`);
    }

    const eventos = await this.roble.read("evento", {
      id_proyecto: idProyecto,
    });

    return eventos.map((item) => ({ ...item }));
  }

  async getEventoById(idEvento: number): Promise<RegistroEvento | null> {
    const eventos = await this.roble.read("evento", {
      id_evento: idEvento,
    });
    return eventos.length > 0 ? { ...eventos[0] } : null;
  }
}
