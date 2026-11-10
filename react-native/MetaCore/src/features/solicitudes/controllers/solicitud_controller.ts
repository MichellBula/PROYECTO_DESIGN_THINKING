import { useCallback, useMemo, useRef, useState } from "react";

import type { SolicitudUI } from "../data/solicitud_data";
import type {
  IntegrantesParaSolicitudesRepository,
} from "../domain/repositories/integrantes_para_solicitudes_repository";
import type { SolicitudRepository } from "../domain/repositories/solicitud_repository";
import { AceptarSolicitud } from "../domain/usecases/aceptar_solicitud";
import { GetMisSolicitudes } from "../domain/usecases/get_mis_solicitudes";
import { GetSolicitudesPendientes } from "../domain/usecases/get_solicitudes_pendientes";
import { ResponderSolicitud } from "../domain/usecases/responder_solicitud";

export type NotificarSolicitud = (
  titulo: string,
  mensaje: string,
  tipo: "success" | "error"
) => void;

function mensajeError(error: unknown): string {
  return (error instanceof Error ? error.message : String(error))
    .replace(/^Exception:\s*/, "")
    .trim();
}

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

function convertirFecha(valor: unknown): Date | null {
  if (valor === null || valor === undefined || String(valor).trim() === "") {
    return null;
  }
  const fecha = new Date(String(valor));
  return Number.isNaN(fecha.getTime()) ? null : fecha;
}

function mapearSolicitud(datos: Record<string, unknown>): SolicitudUI {
  const nombre = texto(datos["nombre_usuario"], "Usuario no disponible");
  const correo = texto(datos["correo_institucional"], "");
  const estado = texto(datos["estado"], "desconocido").toLowerCase();

  const mensajes: Record<string, string> = {
    pendiente: "Solicitud pendiente",
    aceptado: "Solicitud aceptada",
    rechazado: "Solicitud rechazada",
  };

  return {
    idSolicitud: convertirEntero(datos["id_solicitud"]),
    idProyecto: convertirEntero(datos["id_proyecto"]),
    idUsuario: convertirEntero(datos["id_usuario"]),
    idProyectoRol: convertirEntero(datos["id_proyecto_rol"]),
    nombre,
    usuario: correo || `@${nombre.replace(/\s+/g, "")}`,
    proyecto: texto(datos["nombre_proyecto"], "Proyecto no disponible"),
    cargo: texto(datos["nombre_rol"], "Rol no disponible"),
    carrera: texto(datos["carrera"]),
    semestre: texto(datos["semestre_presentacion"]),
    motivo: texto(datos["comentario"], "No se indicó un motivo."),
    mensaje: mensajes[estado] ?? "Estado no disponible",
    estado,
    fechaEnviada: convertirFecha(datos["fecha_enviada"]),
    fechaRespuesta: convertirFecha(datos["fecha_respuesta"]),
  };
}

// Equivalente del GetxController. No se monta ni se conecta a una pantalla aún.
// Recibe interfaces de repositorio; el cliente de Roble no entra en este hook.
export function useSolicitudesController(
  solicitudRepository: SolicitudRepository,
  integranteRepository: IntegrantesParaSolicitudesRepository,
  notificar?: NotificarSolicitud
) {
  const [selectedTab, setSelectedTab] = useState(0);
  const [searchQuery, setSearchQuery] = useState("");
  const [solicitudesRecibidas, setSolicitudesRecibidas] = useState<SolicitudUI[]>([]);
  const [solicitudesEnviadas, setSolicitudesEnviadas] = useState<SolicitudUI[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [procesandoSolicitudId, setProcesandoSolicitudId] = useState<number | null>(null);

  // Los refs bloquean operaciones duplicadas incluso antes de un render.
  const cargandoRef = useRef(false);
  const procesandoRef = useRef(false);

  const casosDeUso = useMemo(
    () => ({
      misSolicitudes: new GetMisSolicitudes(solicitudRepository),
      pendientes: new GetSolicitudesPendientes(solicitudRepository),
      aceptar: new AceptarSolicitud(solicitudRepository, integranteRepository),
      responder: new ResponderSolicitud(solicitudRepository),
    }),
    [solicitudRepository, integranteRepository]
  );

  const cargarSolicitudes = useCallback(async (): Promise<void> => {
    if (cargandoRef.current) return;

    cargandoRef.current = true;
    setIsLoading(true);
    setErrorMessage("");

    try {
      const idUsuario = await solicitudRepository.getIdUsuarioAutenticado();
      const [enviadas, recibidas] = await Promise.all([
        casosDeUso.misSolicitudes.execute(idUsuario),
        casosDeUso.pendientes.execute(idUsuario),
      ]);

      // El datasource ya completa nombres de usuario, proyecto y rol.
      setSolicitudesEnviadas(enviadas.map(mapearSolicitud));
      setSolicitudesRecibidas(recibidas.map(mapearSolicitud));
    } catch (error) {
      setErrorMessage(mensajeError(error));
      setSolicitudesEnviadas([]);
      setSolicitudesRecibidas([]);
      console.error("[SOLICITUDES] Error cargando datos:", error);
    } finally {
      cargandoRef.current = false;
      setIsLoading(false);
    }
  }, [casosDeUso, solicitudRepository]);

  const aceptarSolicitud = useCallback(
    async (solicitud: SolicitudUI): Promise<boolean> => {
      const idSolicitud = solicitud.idSolicitud;
      if (idSolicitud == null) {
        notificar?.("Error", "No se pudo identificar la solicitud.", "error");
        return false;
      }

      if (solicitud.estado.toLowerCase() !== "pendiente") {
        notificar?.(
          "Solicitud no disponible",
          "Solo se pueden aceptar solicitudes pendientes.",
          "error"
        );
        return false;
      }

      if (procesandoRef.current) return false;
      procesandoRef.current = true;
      setProcesandoSolicitudId(idSolicitud);

      try {
        await casosDeUso.aceptar.execute(idSolicitud);
        notificar?.(
          "Solicitud aceptada",
          `${solicitud.nombre} se ha añadido al proyecto.`,
          "success"
        );
        await cargarSolicitudes();
        return true;
      } catch (error) {
        notificar?.("No se pudo aceptar", mensajeError(error), "error");
        return false;
      } finally {
        procesandoRef.current = false;
        setProcesandoSolicitudId(null);
      }
    },
    [casosDeUso, cargarSolicitudes, notificar]
  );

  const rechazarSolicitud = useCallback(
    async (solicitud: SolicitudUI): Promise<boolean> => {
      const idSolicitud = solicitud.idSolicitud;
      if (idSolicitud == null) {
        notificar?.("Error", "No se pudo identificar la solicitud.", "error");
        return false;
      }

      if (solicitud.estado.toLowerCase() !== "pendiente") {
        notificar?.(
          "Solicitud no disponible",
          "Solo se pueden rechazar solicitudes pendientes.",
          "error"
        );
        return false;
      }

      if (procesandoRef.current) return false;
      procesandoRef.current = true;
      setProcesandoSolicitudId(idSolicitud);

      try {
        await casosDeUso.responder.execute({
          idSolicitud,
          nuevoEstado: "rechazado",
        });
        notificar?.(
          "Solicitud rechazada",
          `La solicitud de ${solicitud.nombre} fue rechazada.`,
          "success"
        );
        await cargarSolicitudes();
        return true;
      } catch (error) {
        notificar?.("No se pudo rechazar", mensajeError(error), "error");
        return false;
      } finally {
        procesandoRef.current = false;
        setProcesandoSolicitudId(null);
      }
    },
    [casosDeUso, cargarSolicitudes, notificar]
  );

  const currentList = useMemo(
    () => (selectedTab === 0 ? solicitudesRecibidas : solicitudesEnviadas),
    [selectedTab, solicitudesRecibidas, solicitudesEnviadas]
  );

  const filteredList = useMemo(() => {
    const query = searchQuery.trim().toLowerCase();
    return query
      ? currentList.filter((solicitud) =>
          solicitud.proyecto.toLowerCase().includes(query)
        )
      : currentList;
  }, [currentList, searchQuery]);

  const groupedByProject = useMemo(() => {
    const grouped: Record<string, SolicitudUI[]> = {};
    for (const solicitud of filteredList) {
      (grouped[solicitud.proyecto] ??= []).push(solicitud);
    }
    return grouped;
  }, [filteredList]);

  return {
    selectedTab,
    searchQuery,
    solicitudesRecibidas,
    solicitudesEnviadas,
    isLoading,
    errorMessage,
    procesandoSolicitudId,
    currentList,
    filteredList,
    groupedByProject,
    changeTab: setSelectedTab,
    updateSearch: setSearchQuery,
    cargarSolicitudes,
    aceptarSolicitud,
    rechazarSolicitud,
  };
}
