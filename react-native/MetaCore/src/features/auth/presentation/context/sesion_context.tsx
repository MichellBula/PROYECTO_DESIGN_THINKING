
import {
  createContext,
  useState,
  type ReactNode,
} from "react";

import type { AuthUser } from "../../domain/entities/auth_user";
import type { AuthRepository } from "../../domain/repositories/auth_repository";

// ======================================================
// TIPOS
// ======================================================

type Credenciales = {
  email: string;
  password: string;
};

type DatosRegistro = Credenciales & {
  name: string;
};

// Contrato mínimo del perfil de la feature usuario.
// Lo sustituiremos por la entidad Usuario cuando la migremos.
export interface PerfilUsuario {
  idUsuario: number;
}

type BuscarPerfilUsuario = (
  userId: string
) => Promise<PerfilUsuario | null>;

interface SesionContextType {
  usuarioAutenticado: AuthUser | null;
  perfilUsuario: PerfilUsuario | null;

  cargando: boolean;
  estaAutenticado: boolean;
  tienePerfil: boolean;
  necesitaCompletarPerfil: boolean;
  idUsuario: number | null;

  registrar(datos: DatosRegistro): Promise<boolean>;
  registrarCuenta(datos: DatosRegistro): Promise<boolean>;

  login(datos: Credenciales): Promise<boolean>;
  iniciarSesion(datos: Credenciales): Promise<boolean>;

  restaurarSesion(): Promise<void>;
  actualizarPerfil(): Promise<PerfilUsuario | null>;

  logout(): Promise<void>;
  cerrarSesion(): Promise<void>;
}

interface SesionProviderProps {
  children: ReactNode;
  authRepository: AuthRepository;
  buscarPerfilUsuario?: BuscarPerfilUsuario;
}

// ======================================================
// CONTEXT
// ======================================================

export const SesionContext =
  createContext<SesionContextType | null>(null);

// ======================================================
// PROVIDER
// ======================================================

export function SesionProvider({
  children,
  authRepository,
  buscarPerfilUsuario,
}: SesionProviderProps) {

  // Usuario autenticado mediante Roble Auth.
  const [usuarioAutenticado, setUsuarioAutenticado] =
    useState<AuthUser | null>(null);

  // Perfil almacenado en la tabla usuario.
  const [perfilUsuario, setPerfilUsuario] =
    useState<PerfilUsuario | null>(null);

  // Estado de carga.
  const [cargando, setCargando] = useState(false);

  // Indica si se ha podido consultar la tabla usuario.
  const [perfilConsultado, setPerfilConsultado] =
    useState(false);

  // ======================================================
  // ESTADOS CALCULADOS
  // ======================================================

  const estaAutenticado = usuarioAutenticado !== null;

  const tienePerfil = perfilUsuario !== null;

  const necesitaCompletarPerfil =
    estaAutenticado && perfilConsultado && !tienePerfil;

  const idUsuario = perfilUsuario?.idUsuario ?? null;

  // ======================================================
  // FUNCIONES AUXILIARES
  // ======================================================

  function limpiarSesion(): void {
    setUsuarioAutenticado(null);
    setPerfilUsuario(null);
    setPerfilConsultado(false);
  }

  async function cargarPerfil(userId: string): Promise<void> {
    if (!buscarPerfilUsuario) {
      setPerfilUsuario(null);
      setPerfilConsultado(false);
      return;
    }

    const perfil = await buscarPerfilUsuario(userId);

    setPerfilUsuario(perfil);
    setPerfilConsultado(true);
  }

  // ======================================================
  // REGISTRAR SIN INICIAR SESIÓN
  // Equivale a AuthController.registrar()
  // ======================================================

  async function registrar(
    datos: DatosRegistro
  ): Promise<boolean> {
    try {
      setCargando(true);

      await authRepository.registrar(datos);

      return true;
    } catch (error) {
      limpiarSesion();
      throw error;
    } finally {
      setCargando(false);
    }
  }

  // ======================================================
  // REGISTRAR E INICIAR SESIÓN AUTOMÁTICAMENTE
  // Equivale a SesionController.registrarCuenta()
  // ======================================================

  async function registrarCuenta(
    datos: DatosRegistro
  ): Promise<boolean> {
    try {
      setCargando(true);

      // 1. Registrar en Roble Auth.
      await authRepository.registrar(datos);

      // 2. Iniciar sesión automáticamente.
      const authUser = await authRepository.login({
        email: datos.email,
        password: datos.password,
      });

      // 3. Consultar el perfil cuando esté integrado.
      await cargarPerfil(authUser.userId);

      setUsuarioAutenticado(authUser);

      return true;
    } catch (error) {
      limpiarSesion();
      throw error;
    } finally {
      setCargando(false);
    }
  }

  // ======================================================
  // INICIAR SESIÓN
  // ======================================================

  async function iniciarSesion(
    datos: Credenciales
  ): Promise<boolean> {
    try {
      setCargando(true);

      // 1. Autenticación con Roble.
      const authUser = await authRepository.login(datos);

      // 2. Obtener perfil de la tabla usuario.
      await cargarPerfil(authUser.userId);

      // 3. Actualizar sesión.
      setUsuarioAutenticado(authUser);

      return true;
    } catch (error) {
      limpiarSesion();
      throw error;
    } finally {
      setCargando(false);
    }
  }

  // ======================================================
  // RESTAURAR SESIÓN
  // ======================================================

  async function restaurarSesion(): Promise<void> {
    try {
      setCargando(true);

      await authRepository.restaurarSesion();

      const authUser =
        await authRepository.obtenerUsuarioActual();

      if (authUser === null) {
        limpiarSesion();
        return;
      }

      await cargarPerfil(authUser.userId);

      setUsuarioAutenticado(authUser);
    } catch (error) {
      limpiarSesion();
      throw error;
    } finally {
      setCargando(false);
    }
  }

  // ======================================================
  // ACTUALIZAR PERFIL
  // ======================================================

  async function actualizarPerfil():
    Promise<PerfilUsuario | null> {

    if (usuarioAutenticado === null) {
      setPerfilUsuario(null);
      setPerfilConsultado(false);
      return null;
    }

    if (!buscarPerfilUsuario) {
      throw new Error(
        "Todavía no está conectado el repositorio de usuario."
      );
    }

    try {
      setCargando(true);

      const perfil = await buscarPerfilUsuario(
        usuarioAutenticado.userId
      );

      setPerfilUsuario(perfil);
      setPerfilConsultado(true);

      return perfil;
    } finally {
      setCargando(false);
    }
  }

  // ======================================================
  // CERRAR SESIÓN
  // ======================================================

  async function cerrarSesion(): Promise<void> {
    try {
      setCargando(true);

      await authRepository.logout();
    } finally {
      limpiarSesion();
      setCargando(false);
    }
  }

  // ======================================================
  // COMPARTIR ESTADO Y OPERACIONES
  // ======================================================

  return (
    <SesionContext.Provider
      value={{
        usuarioAutenticado,
        perfilUsuario,
        cargando,
        estaAutenticado,
        tienePerfil,
        necesitaCompletarPerfil,
        idUsuario,

        registrar,
        registrarCuenta,

        login: iniciarSesion,
        iniciarSesion,

        restaurarSesion,
        actualizarPerfil,

        logout: cerrarSesion,
        cerrarSesion,
      }}
    >
      {children}
    </SesionContext.Provider>
  );
}
