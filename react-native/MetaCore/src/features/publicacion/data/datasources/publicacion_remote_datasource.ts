import type { RobleApiClient } from "roble-client";

import type { RegistroPublicacion } from "../../domain/entities/publicacion";
import { PublicacionModel } from "../../models/publicacion_model";

function convertirEntero(valor: unknown): number | null {
  if (valor === null || valor === undefined) return null;
  const texto = String(valor).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;
  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

function convertirFecha(valor: unknown): number | null {
  if (valor === null || valor === undefined) return null;
  const fecha = new Date(String(valor));
  const tiempo = fecha.getTime();
  return Number.isNaN(tiempo) ? null : tiempo;
}

// Recibe el cliente del módulo `core/roble`, por inyección de dependencias.
export class PublicacionRemoteDatasource {
  private static readonly MAX_INTENTOS_CREAR = 5;

  constructor(private readonly roble: RobleApiClient) {}

  private async obtenerSiguienteId(): Promise<number> {
    const publicaciones = await this.roble.read("publicacion");
    let mayorId = 0;

    for (const publicacion of publicaciones) {
      const id = convertirEntero(publicacion["id_publicacion"]);
      if (id !== null && id > mayorId) mayorId = id;
    }

    return mayorId + 1;
  }

  private async idExiste(idPublicacion: number): Promise<boolean> {
    const publicaciones = await this.roble.read("publicacion", {
      id_publicacion: idPublicacion,
    });
    return publicaciones.length > 0;
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

  async createPublicacion(
    publicacion: PublicacionModel
  ): Promise<RegistroPublicacion> {
    if (!publicacion.titulo.trim()) {
      throw new Error("El título de la publicación no puede estar vacío.");
    }

    if (!publicacion.contenido.trim()) {
      throw new Error("El contenido de la publicación no puede estar vacío.");
    }

    if (Number.isNaN(publicacion.fechaPublicacion.getTime())) {
      throw new Error("La fecha de publicación no es válida.");
    }

    // Una consulta basta para verificar el proyecto y conocer a su creador.
    const idCreador = await this.obtenerIdCreadorDelProyecto(
      publicacion.idProyecto
    );
    const idUsuarioAutenticado = await this.obtenerIdUsuarioAutenticado();

    if (idUsuarioAutenticado !== idCreador) {
      throw new Error(
        "Solo el creador del proyecto puede crear publicaciones."
      );
    }

    for (
      let intento = 1;
      intento <= PublicacionRemoteDatasource.MAX_INTENTOS_CREAR;
      intento++
    ) {
      const idPublicacion = await this.obtenerSiguienteId();

      try {
        const resultado = await this.roble.create(
          "publicacion",
          publicacion.toMap({ idPublicacion })
        );

        return { ...resultado };
      } catch (error) {
        // Reintenta únicamente si el ID elegido ahora está ocupado.
        const idFueOcupado = await this.idExiste(idPublicacion);
        if (
          !idFueOcupado ||
          intento === PublicacionRemoteDatasource.MAX_INTENTOS_CREAR
        ) {
          throw error;
        }
      }
    }

    throw new Error("No fue posible crear la publicación.");
  }

  async getPublicacionesByProject(
    idProyecto: number
  ): Promise<RegistroPublicacion[]> {
    const publicaciones = await this.roble.read("publicacion", {
      id_proyecto: idProyecto,
    });

    return publicaciones.map((item) => ({ ...item }));
  }

  async getPublicacionById(
    idPublicacion: number
  ): Promise<RegistroPublicacion | null> {
    const publicaciones = await this.roble.read("publicacion", {
      id_publicacion: idPublicacion,
    });

    return publicaciones.length ? { ...publicaciones[0] } : null;
  }

  async getTodasLasPublicaciones(): Promise<RegistroPublicacion[]> {
    const publicaciones = await this.roble.read("publicacion");
    const resultado = publicaciones.map((item) => ({ ...item }));

    // Más recientes primero. Los registros sin fecha válida van al final.
    resultado.sort((a, b) => {
      const fechaA = convertirFecha(a["fecha_publicacion"]);
      const fechaB = convertirFecha(b["fecha_publicacion"]);

      if (fechaA === null && fechaB === null) return 0;
      if (fechaA === null) return 1;
      if (fechaB === null) return -1;
      return fechaB - fechaA;
    });

    return resultado;
  }
}
