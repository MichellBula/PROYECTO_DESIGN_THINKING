import type { RobleApiClient } from "roble-client";

import { Usuario, type CrearUsuarioParams } from "../../domain/entities/usuario";
import type { UsuarioRemoteDataSource } from "./usuario_remote_data_source";

function convertirEntero(valor: unknown): number | null {
  if (valor === null || valor === undefined) return null;
  const texto = String(valor).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;
  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

function convertirDecimal(valor: unknown): number | null {
  if (valor === null || valor === undefined) return null;
  const texto = String(valor).trim();
  if (!texto) return null;
  const numero = Number(texto);
  return Number.isFinite(numero) ? numero : null;
}

function convertirTextoObligatorio(
  registro: Record<string, unknown>,
  campo: string
): string {
  const valor = registro[campo];
  if (valor === null || valor === undefined) {
    throw new Error(`El campo ${campo} no está presente en el perfil de usuario.`);
  }
  return String(valor);
}

export class UsuarioRemoteDataSourceImpl implements UsuarioRemoteDataSource {
  private static readonly MAX_INTENTOS_CREAR = 5;

  constructor(private readonly roble: RobleApiClient) {}

  private mapearUsuario(data: Record<string, unknown>): Usuario {
    const idUsuario = convertirEntero(data["id_usuario"]);
    const semestre = convertirEntero(data["semestre"]);

    if (idUsuario === null || semestre === null) {
      throw new Error("El perfil no tiene un id_usuario o semestre válido.");
    }

    return new Usuario(
      idUsuario,
      convertirTextoObligatorio(data, "nombre_usuario"),
      convertirTextoObligatorio(data, "correo_institucional"),
      convertirTextoObligatorio(data, "carrera"),
      semestre,
      convertirTextoObligatorio(data, "id_autenticador"),
      convertirEntero(data["numero_proyectos"]),
      convertirDecimal(data["calificacion_usuario"])
    );
  }

  private async obtenerSiguienteIdUsuario(): Promise<number> {
    const registros = await this.roble.read("usuario");
    let mayorId = 0;

    for (const registro of registros) {
      const id = convertirEntero(registro["id_usuario"]);
      if (id !== null && id > mayorId) mayorId = id;
    }

    return mayorId + 1;
  }

  private async idYaExiste(idUsuario: number): Promise<boolean> {
    const registros = await this.roble.read("usuario", {
      id_usuario: idUsuario,
    });
    return registros.length > 0;
  }

  async crearUsuario(params: CrearUsuarioParams): Promise<Usuario> {
    for (
      let intento = 1;
      intento <= UsuarioRemoteDataSourceImpl.MAX_INTENTOS_CREAR;
      intento++
    ) {
      const idUsuario = await this.obtenerSiguienteIdUsuario();

      try {
        const resultado = await this.roble.create("usuario", {
          id_usuario: idUsuario,
          nombre_usuario: params.nombreUsuario,
          correo_institucional: params.correoInstitucional,
          carrera: params.carrera,
          semestre: params.semestre,
          id_autenticador: params.idAutenticador,
          numero_proyectos: null,
          calificacion_usuario: null,
        });

        return this.mapearUsuario({ ...resultado });
      } catch (error) {
        // Si la operación se guardó pero falló la respuesta,
        // recuperamos ese perfil antes de intentar un nuevo ID.
        const porAutenticador = await this.obtenerUsuarioActual(
          params.idAutenticador
        );
        if (porAutenticador && porAutenticador.idUsuario === idUsuario) {
          return porAutenticador;
        }

        if (porAutenticador) {
          throw new Error(
            "Ya existe un perfil asociado a este usuario de Roble Auth."
          );
        }

        const idFueOcupado = await this.idYaExiste(idUsuario);
        if (
          !idFueOcupado ||
          intento === UsuarioRemoteDataSourceImpl.MAX_INTENTOS_CREAR
        ) {
          throw error;
        }
      }
    }

    throw new Error("No fue posible generar un id_usuario disponible.");
  }

  async obtenerUsuarioActual(idAutenticador: string): Promise<Usuario | null> {
    const registros = await this.roble.read("usuario", {
      id_autenticador: idAutenticador,
    });

    return registros.length > 0
      ? this.mapearUsuario({ ...registros[0] })
      : null;
  }

  async obtenerUsuarioPorId(idUsuario: number): Promise<Usuario | null> {
    const registros = await this.roble.read("usuario", {
      id_usuario: idUsuario,
    });

    return registros.length > 0
      ? this.mapearUsuario({ ...registros[0] })
      : null;
  }
}
