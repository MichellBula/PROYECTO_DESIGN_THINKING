
import { RobleApiClient } from "roble-client";

export class UsuarioStatsService {
  constructor(private readonly roble: RobleApiClient) {}

  // Convierte un valor a entero cuando es válido.
  private convertirEntero(valor: unknown): number | null {
    if (valor === null || valor === undefined) {
      return null;
    }

    const texto = String(valor).trim();

    if (!/^[+-]?\d+$/.test(texto)) {
      return null;
    }

    const numero = Number(texto);

    return Number.isSafeInteger(numero) ? numero : null;
  }

  // Convierte un valor a decimal cuando es válido.
  private convertirDecimal(valor: unknown): number | null {
    if (
      valor === null ||
      valor === undefined ||
      (typeof valor !== "string" && typeof valor !== "number")
    ) {
      return null;
    }

    if (String(valor).trim() === "") {
      return null;
    }

    const numero = Number(valor);

    return Number.isFinite(numero) ? numero : null;
  }

  // Actualiza las estadísticas de un usuario.
  async sincronizarUsuario(idUsuario: number): Promise<void> {
    const proyectosCreados = await this.roble.read(
      "proyecto",
      { id_creador: idUsuario }
    );

    const integrantes = await this.roble.read(
      "integrantes",
      { id_usuario: idUsuario }
    );

    const idsProyectos = new Set<number>();

    // Agregar proyectos creados.
    for (const proyecto of proyectosCreados) {
      const idProyecto = this.convertirEntero(
        proyecto["id_proyecto"]
      );

      if (idProyecto !== null) {
        idsProyectos.add(idProyecto);
      }
    }

    // Agregar proyectos donde participa.
    for (const integrante of integrantes) {
      const idProyecto = this.convertirEntero(
        integrante["id_proyecto"]
      );

      if (idProyecto !== null) {
        idsProyectos.add(idProyecto);
      }
    }

    // Obtener todos los proyectos.
    const todosLosProyectos = await this.roble.read("proyecto");

    const calificaciones: number[] = [];

    for (const proyecto of todosLosProyectos) {
      const idProyecto = this.convertirEntero(
        proyecto["id_proyecto"]
      );

      if (
        idProyecto === null ||
        !idsProyectos.has(idProyecto)
      ) {
        continue;
      }

      const calificacion = this.convertirDecimal(
        proyecto["calificacion"]
      );

      if (calificacion !== null) {
        calificaciones.push(calificacion);
      }
    }

    // Calcular número de proyectos.
    const numeroProyectos: number | null =
      idsProyectos.size === 0 ? null : idsProyectos.size;

    // Calcular calificación promedio.
    let calificacionUsuario: number | null = null;

    if (calificaciones.length > 0) {
      const suma = calificaciones.reduce(
        (total, actual) => total + actual,
        0
      );

      const promedio = suma / calificaciones.length;

      calificacionUsuario = Number(promedio.toFixed(2));
    }

    // Buscar usuario en Roble.
    const usuarios = await this.roble.read(
      "usuario",
      { id_usuario: idUsuario }
    );

    if (usuarios.length === 0) {
      throw new Error(
        `No se encontró el usuario con id_usuario=${idUsuario}.`
      );
    }

    const usuario = usuarios[0];

    const robleId =
      usuario["_id"] === null || usuario["_id"] === undefined
        ? ""
        : String(usuario["_id"]);

    if (robleId.length === 0) {
      throw new Error(
        `El usuario ${idUsuario} no tiene un _id válido de Roble.`
      );
    }

    // Actualizar estadísticas.
    await this.roble.update(
      "usuario",
      robleId,
      {
        numero_proyectos: numeroProyectos,
        calificacion_usuario: calificacionUsuario,
      }
    );
  }

  // Actualiza los usuarios de un proyecto.
  async sincronizarPorProyecto(idProyecto: number): Promise<void> {
    const proyectos = await this.roble.read(
      "proyecto",
      { id_proyecto: idProyecto }
    );

    if (proyectos.length === 0) {
      throw new Error(
        `No se encontró el proyecto con id_proyecto=${idProyecto}.`
      );
    }

    const proyecto = proyectos[0];

    const idsUsuarios = new Set<number>();

    // Agregar al creador.
    const idCreador = this.convertirEntero(
      proyecto["id_creador"]
    );

    if (idCreador !== null) {
      idsUsuarios.add(idCreador);
    }

    // Obtener integrantes.
    const integrantes = await this.roble.read(
      "integrantes",
      { id_proyecto: idProyecto }
    );

    for (const integrante of integrantes) {
      const idUsuario = this.convertirEntero(
        integrante["id_usuario"]
      );

      if (idUsuario !== null) {
        idsUsuarios.add(idUsuario);
      }
    }

    // Sincronizar estadísticas de cada usuario.
    for (const idUsuario of idsUsuarios) {
      await this.sincronizarUsuario(idUsuario);
    }
  }
}
