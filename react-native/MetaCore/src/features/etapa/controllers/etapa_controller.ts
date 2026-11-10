import { useCallback, useMemo, useRef, useState } from "react";

import { Etapa, type RegistroEtapa } from "../domain/entities/etapa";
import type { EtapaRepository } from "../domain/repositories/etapa_repository";
import { CreateEtapa } from "../domain/usecases/create_etapa";
import { GetEtapaById } from "../domain/usecases/get_etapa_by_id";
import { GetEtapasByProject } from "../domain/usecases/get_etapas_by_project";

export type NotificarEtapa = (
  titulo: string,
  mensaje: string,
  tipo: "success" | "error"
) => void;

function mensajeError(error: unknown): string {
  return (error instanceof Error ? error.message : String(error))
    .replace(/^Exception:\s*/, "");
}

// Equivalente del GetxController, sin implementar todavía una pantalla.
// Este hook se usará dentro de componentes de React Native.
export function useEtapaController(
  repository: EtapaRepository,
  notificar?: NotificarEtapa
) {
  const [cargando, setCargando] = useState(false);
  const [creando, setCreando] = useState(false);
  const [etapas, setEtapas] = useState<RegistroEtapa[]>([]);
  const [error, setError] = useState<string | null>(null);

  // Impide dobles clics mientras React actualiza la pantalla.
  const creandoRef = useRef(false);

  const casosDeUso = useMemo(
    () => ({
      crear: new CreateEtapa(repository),
      porId: new GetEtapaById(repository),
      porProyecto: new GetEtapasByProject(repository),
    }),
    [repository]
  );

  const cargarEtapas = useCallback(
    async (idProyecto: number): Promise<void> => {
      setCargando(true);
      setError(null);

      try {
        const resultado = await casosDeUso.porProyecto.execute(idProyecto);
        setEtapas(resultado);
      } catch (e) {
        setError(mensajeError(e));
        console.error("[ETAPA_CONTROLLER] Error cargando etapas:", e);
      } finally {
        setCargando(false);
      }
    },
    [casosDeUso]
  );

  const crearEtapa = useCallback(
    async (params: {
      idProyecto: number;
      nombreEtapa: string;
      orden: number;
    }): Promise<RegistroEtapa | null> => {
      if (creandoRef.current) return null;

      creandoRef.current = true;
      setCreando(true);
      setError(null);

      try {
        const etapa = new Etapa(
          params.idProyecto,
          params.nombreEtapa.trim(),
          params.orden
        );

        const resultado = await casosDeUso.crear.execute(etapa);
        await cargarEtapas(params.idProyecto);

        notificar?.("Etapa creada", "La etapa se guardó correctamente.", "success");
        return resultado;
      } catch (e) {
        const mensaje = mensajeError(e);
        setError(mensaje);
        notificar?.("No se pudo crear la etapa", mensaje, "error");
        return null;
      } finally {
        creandoRef.current = false;
        setCreando(false);
      }
    },
    [casosDeUso, cargarEtapas, notificar]
  );

  const obtenerEtapaPorId = useCallback(
    async (idEtapa: number): Promise<RegistroEtapa | null> => {
      try {
        return await casosDeUso.porId.execute(idEtapa);
      } catch (e) {
        setError(mensajeError(e));
        return null;
      }
    },
    [casosDeUso]
  );

  return {
    cargando,
    creando,
    etapas,
    error,
    cargarEtapas,
    crearEtapa,
    obtenerEtapaPorId,
  };
}
