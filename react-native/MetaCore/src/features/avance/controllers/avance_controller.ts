import { useCallback, useMemo, useRef, useState } from "react";

import { Avance, type RegistroAvance } from "../domain/entities/avance";
import type { AvanceRepository } from "../domain/repositories/avance_repository";
import { CreateAvance } from "../domain/usecases/create_avance";
import { GetAvanceById } from "../domain/usecases/get_avance_by_id";
import { GetAvancesByEtapa } from "../domain/usecases/get_avances_by_etapa";
import { GetAvancesByProject } from "../domain/usecases/get_avances_by_project";

// Get.snackbar de Flutter se sustituye por una función opcional.
// La pantalla podrá conectarla a Alert, un Toast, etc. más adelante.
export type NotificarAvance = (
  titulo: string,
  mensaje: string,
  tipo: "success" | "error" | "warning"
) => void;

function mensajeDeError(error: unknown): string {
  return (error instanceof Error ? error.message : String(error))
    .replace(/^Exception:\s*/, "");
}

export function useAvanceController(
  repository: AvanceRepository,
  notificar?: NotificarAvance
) {
  const [cargando, setCargando] = useState(false);
  const [creando, setCreando] = useState(false);
  const [avances, setAvances] = useState<RegistroAvance[]>([]);
  const [porcentajeEtapa, setPorcentajeEtapa] = useState(0);
  const [error, setError] = useState<string | null>(null);

  // Impide dos creaciones simultáneas aunque React aún no haya renderizado.
  const creandoRef = useRef(false);

  const casosDeUso = useMemo(
    () => ({
      create: new CreateAvance(repository),
      byId: new GetAvanceById(repository),
      byEtapa: new GetAvancesByEtapa(repository),
      byProject: new GetAvancesByProject(repository),
    }),
    [repository]
  );

  // ==========================================================
  // CARGAR AVANCES DE ETAPA
  // ==========================================================

  const cargarAvancesPorEtapa = useCallback(
    async (idEtapa: number): Promise<void> => {
      setCargando(true);
      setError(null);

      try {
        const resultado = await casosDeUso.byEtapa.execute(idEtapa);
        const porcentaje = await repository.getPorcentajeByEtapa(idEtapa);
        setAvances(resultado);
        setPorcentajeEtapa(porcentaje);
      } catch (e) {
        setError(mensajeDeError(e));
        console.error("[AVANCE_CONTROLLER] Error cargando avances:", e);
      } finally {
        setCargando(false);
      }
    },
    [casosDeUso, repository]
  );

  // ==========================================================
  // CARGAR AVANCES DE PROYECTO
  // ==========================================================

  const cargarAvancesPorProyecto = useCallback(
    async (idProyecto: number): Promise<RegistroAvance[]> => {
      setCargando(true);
      setError(null);

      try {
        const resultado = await casosDeUso.byProject.execute(idProyecto);
        setAvances(resultado);
        return resultado;
      } catch (e) {
        setError(mensajeDeError(e));
        console.error(
          "[AVANCE_CONTROLLER] Error cargando avances del proyecto:",
          e
        );
        return [];
      } finally {
        setCargando(false);
      }
    },
    [casosDeUso]
  );

  // ==========================================================
  // CREAR AVANCE
  // ==========================================================

  const crearAvance = useCallback(
    async (params: {
      idEtapa: number;
      comentario: string;
    }): Promise<RegistroAvance | null> => {
      if (creandoRef.current) return null;

      const comentario = params.comentario.trim();
      if (comentario.length === 0) {
        const mensaje = "Escribe qué se hizo antes de registrar el avance.";
        setError(mensaje);
        notificar?.("Comentario obligatorio", mensaje, "warning");
        return null;
      }

      creandoRef.current = true;
      setCreando(true);
      setError(null);

      try {
        const avance = new Avance(params.idEtapa, comentario, new Date());
        const resultado = await casosDeUso.create.execute(avance);

        await cargarAvancesPorEtapa(params.idEtapa);
        notificar?.(
          "Avance registrado",
          "El progreso de la etapa se actualizó correctamente.",
          "success"
        );

        return resultado;
      } catch (e) {
        const mensaje = mensajeDeError(e);
        setError(mensaje);
        notificar?.("No se pudo registrar el avance", mensaje, "error");
        return null;
      } finally {
        creandoRef.current = false;
        setCreando(false);
      }
    },
    [casosDeUso, cargarAvancesPorEtapa, notificar]
  );

  // ==========================================================
  // CONSULTAR AVANCE POR ID
  // ==========================================================

  const obtenerAvancePorId = useCallback(
    async (idAvance: number): Promise<RegistroAvance | null> => {
      try {
        return await casosDeUso.byId.execute(idAvance);
      } catch (e) {
        setError(mensajeDeError(e));
        return null;
      }
    },
    [casosDeUso]
  );

  return {
    cargando,
    creando,
    avances,
    porcentajeEtapa,
    error,
    cargarAvancesPorEtapa,
    cargarAvancesPorProyecto,
    crearAvance,
    obtenerAvancePorId,
  };
}
