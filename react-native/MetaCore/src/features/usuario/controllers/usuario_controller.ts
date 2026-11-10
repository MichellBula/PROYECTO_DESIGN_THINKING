import { useCallback, useState } from "react";

import type { CrearUsuarioParams, Usuario } from "../domain/entities/usuario";
import type { UsuarioRepository } from "../domain/repositories/usuario_repository";

// Equivalente del GetxController de Flutter, para usar en una pantalla futura.
export function useUsuarioController(repository: UsuarioRepository) {
  const [perfilUsuario, setPerfilUsuario] = useState<Usuario | null>(null);
  const [cargando, setCargando] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const obtenerMiPerfil = useCallback(
    async (idAutenticador: string): Promise<Usuario | null> => {
      setCargando(true);
      setError(null);

      try {
        const usuario = await repository.obtenerUsuarioActual(idAutenticador);
        setPerfilUsuario(usuario);
        return usuario;
      } catch (e) {
        setError(e instanceof Error ? e.message : String(e));
        throw e;
      } finally {
        setCargando(false);
      }
    },
    [repository]
  );

  const crearPerfil = useCallback(
    async (params: CrearUsuarioParams): Promise<Usuario> => {
      setCargando(true);
      setError(null);

      try {
        const usuario = await repository.crearUsuario(params);
        setPerfilUsuario(usuario);
        return usuario;
      } catch (e) {
        setError(e instanceof Error ? e.message : String(e));
        throw e;
      } finally {
        setCargando(false);
      }
    },
    [repository]
  );

  return {
    perfilUsuario,
    cargando,
    error,
    tienePerfil: perfilUsuario !== null,
    obtenerMiPerfil,
    crearPerfil,
  };
}
