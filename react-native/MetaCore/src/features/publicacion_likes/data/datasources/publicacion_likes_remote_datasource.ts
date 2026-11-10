import type { RobleApiClient } from "roble-client";

import type {
  RegistroPublicacionLike,
  UsuarioYPublicacion,
} from "../../domain/entities/publicacion_like";
import { PublicacionLikeModel } from "../../models/publicacion_like_model";

function convertirEntero(valor: unknown): number | null {
  if (valor === undefined || valor === null) return null;
  const texto = String(valor).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;
  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

// Recibe el cliente de Roble por inyección de dependencias desde `core/roble`.
export class PublicacionLikesRemoteDatasource {
  private static readonly MAX_INTENTOS_CREAR = 5;

  constructor(private readonly roble: RobleApiClient) {}

  private async obtenerSiguienteId(): Promise<number> {
    const likes = await this.roble.read("publicacion_likes");
    let mayorId = 0;

    for (const like of likes) {
      const id = convertirEntero(like["id_publicacion_likes"]);
      if (id !== null && id > mayorId) mayorId = id;
    }

    return mayorId + 1;
  }

  private async idExiste(idPublicacionLikes: number): Promise<boolean> {
    const likes = await this.roble.read("publicacion_likes", {
      id_publicacion_likes: idPublicacionLikes,
    });
    return likes.length > 0;
  }

  private async buscarLikeExistente(
    params: UsuarioYPublicacion
  ): Promise<RegistroPublicacionLike | null> {
    const likes = await this.roble.read("publicacion_likes", {
      id_usuario: params.idUsuario,
      id_publicacion: params.idPublicacion,
    });

    return likes.length > 0 ? { ...likes[0] } : null;
  }

  async createPublicacionLike(
    like: PublicacionLikeModel
  ): Promise<RegistroPublicacionLike> {
    const usuarios = await this.roble.read("usuario", {
      id_usuario: like.idUsuario,
    });

    if (usuarios.length === 0) {
      throw new Error(`No existe el usuario ${like.idUsuario}.`);
    }

    const publicaciones = await this.roble.read("publicacion", {
      id_publicacion: like.idPublicacion,
    });

    if (publicaciones.length === 0) {
      throw new Error(`No existe la publicación ${like.idPublicacion}.`);
    }

    const params: UsuarioYPublicacion = {
      idUsuario: like.idUsuario,
      idPublicacion: like.idPublicacion,
    };

    const existente = await this.buscarLikeExistente(params);
    if (existente) {
      throw new Error("El usuario ya dio like a esta publicación.");
    }

    for (
      let intento = 1;
      intento <= PublicacionLikesRemoteDatasource.MAX_INTENTOS_CREAR;
      intento++
    ) {
      const idPublicacionLikes = await this.obtenerSiguienteId();

      try {
        const resultado = await this.roble.create(
          "publicacion_likes",
          like.toMap({ idPublicacionLikes })
        );

        return { ...resultado };
      } catch (error) {
        // Si el servidor insertó el like, pero la respuesta se perdió,
        // lo recuperamos en vez de crear un duplicado con otro ID.
        const trasError = await this.buscarLikeExistente(params);
        if (trasError) {
          if (
            convertirEntero(trasError["id_publicacion_likes"]) ===
            idPublicacionLikes
          ) {
            return trasError;
          }

          throw new Error("El usuario ya dio like a esta publicación.");
        }

        const idFueOcupado = await this.idExiste(idPublicacionLikes);
        if (
          !idFueOcupado ||
          intento === PublicacionLikesRemoteDatasource.MAX_INTENTOS_CREAR
        ) {
          throw error;
        }
      }
    }

    throw new Error("No fue posible crear el like.");
  }

  async getLikesByPublicacion(
    idPublicacion: number
  ): Promise<RegistroPublicacionLike[]> {
    const likes = await this.roble.read("publicacion_likes", {
      id_publicacion: idPublicacion,
    });

    return likes.map((item) => ({ ...item }));
  }

  getPublicacionLikeByUserAndPublicacion(
    params: UsuarioYPublicacion
  ): Promise<RegistroPublicacionLike | null> {
    return this.buscarLikeExistente(params);
  }

  async deletePublicacionLikeByUserAndPublicacion(
    params: UsuarioYPublicacion
  ): Promise<boolean> {
    const existente = await this.buscarLikeExistente(params);
    if (!existente) return false;

    const robleId = existente["_id"]?.toString();
    if (!robleId) {
      throw new Error("El like no tiene un _id válido de Roble.");
    }

    await this.roble.delete("publicacion_likes", robleId);
    return true;
  }
}
