import type { RobleApiClient } from "roble-client";

import type { RegistroComentario } from "../../domain/entities/comentario";
import { ComentarioModel } from "../../models/comentario_model";

// int.tryParse del código Dart, sin convertir valores nulos a cero.
function toInt(value: unknown): number | null {
  if (value === null || value === undefined) return null;
  const texto = String(value).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;

  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

export class ComentarioRemoteDatasource {
  private static readonly MAX_INTENTOS_CREAR_COMENTARIO = 5;

  // Usar la misma instancia de RobleClient configurada en core.
  constructor(private readonly roble: RobleApiClient) {}

  private async obtenerSiguienteId(): Promise<number> {
    const comentarios = await this.roble.read("comentario");
    let mayorId = 0;

    for (const comentario of comentarios) {
      const id = toInt(comentario["id_comentario"]);
      if (id !== null && id > mayorId) mayorId = id;
    }

    return mayorId + 1;
  }

  private async idExiste(idComentario: number): Promise<boolean> {
    const comentarios = await this.roble.read("comentario", {
      id_comentario: idComentario,
    });
    return comentarios.length > 0;
  }

  private async obtenerIdUsuarioAutenticado(): Promise<number> {
    const user = await this.roble.currentUser();
    const userId = user?.userId?.toString();

    if (!userId) {
      throw new Error("No fue posible obtener el usuario autenticado.");
    }

    // Relación entre la cuenta Roble Auth y la tabla propia `usuario`.
    const usuarios = await this.roble.read("usuario", {
      id_autenticador: userId,
    });

    if (usuarios.length === 0) {
      throw new Error(
        "No existe un perfil de usuario asociado a la cuenta autenticada."
      );
    }

    const idUsuario = toInt(usuarios[0]["id_usuario"]);
    if (idUsuario === null) {
      throw new Error("El perfil de usuario no tiene un id_usuario válido.");
    }

    return idUsuario;
  }

  private async verificarPublicacion(idPublicacion: number): Promise<void> {
    const publicaciones = await this.roble.read("publicacion", {
      id_publicacion: idPublicacion,
    });

    if (publicaciones.length === 0) {
      throw new Error(`No existe la publicación ${idPublicacion}.`);
    }
  }

  async createComentario(comentario: ComentarioModel): Promise<RegistroComentario> {
    if (comentario.contenido.trim().length === 0) {
      throw new Error("El contenido del comentario no puede estar vacío.");
    }

    await this.verificarPublicacion(comentario.idPublicacion);

    const idUsuarioAutenticado = await this.obtenerIdUsuarioAutenticado();
    if (idUsuarioAutenticado !== comentario.idUsuario) {
      throw new Error("El comentario debe pertenecer al usuario autenticado.");
    }

    for (
      let intento = 1;
      intento <= ComentarioRemoteDatasource.MAX_INTENTOS_CREAR_COMENTARIO;
      intento++
    ) {
      const idComentario = await this.obtenerSiguienteId();

      try {
        return await this.roble.create(
          "comentario",
          comentario.toMap({ idComentario })
        );
      } catch (error) {
        // En Flutter, solo se reintenta si el ID ya quedó ocupado.
        const idFueOcupado = await this.idExiste(idComentario);

        if (
          !idFueOcupado ||
          intento === ComentarioRemoteDatasource.MAX_INTENTOS_CREAR_COMENTARIO
        ) {
          throw error;
        }
      }
    }

    throw new Error("No fue posible crear el comentario.");
  }

  async getComentariosByPublicacion(
    idPublicacion: number
  ): Promise<RegistroComentario[]> {
    await this.verificarPublicacion(idPublicacion);

    const comentarios = await this.roble.read("comentario", {
      id_publicacion: idPublicacion,
    });

    return comentarios.map((item) => ({ ...item }));
  }

  async getComentarioById(idComentario: number): Promise<RegistroComentario | null> {
    const comentarios = await this.roble.read("comentario", {
      id_comentario: idComentario,
    });

    return comentarios.length > 0 ? { ...comentarios[0] } : null;
  }
}
