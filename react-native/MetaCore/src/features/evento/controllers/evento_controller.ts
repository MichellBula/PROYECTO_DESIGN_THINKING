import { useCallback, useMemo, useState } from "react";

import type { RegistroEvento } from "../domain/entities/evento";
import type { EventoRepository } from "../domain/repositories/evento_repository";
import { GetEventosByProject } from "../domain/usecases/get_eventos_by_project";

export interface EventoUI {
  nombre: string;
  tipo: string;
  descripcion: string;
  fechaInicio: Date;
  fechaFinal: Date;
}

function parsearFecha(valor: unknown): Date | null {
  if (valor === null || valor === undefined) return null;

  let fecha: Date;
  if (typeof valor === "number") {
    // Como DateTime.fromMillisecondsSinceEpoch de Dart.
    fecha = new Date(valor);
  } else if (typeof valor === "string" && valor.trim()) {
    fecha = new Date(valor);
  } else {
    return null;
  }

  return Number.isNaN(fecha.getTime()) ? null : fecha;
}

function mapearEvento(raw: RegistroEvento): EventoUI | null {
  const fechaInicio = parsearFecha(raw["fecha_inicio"]);
  const fechaFinal = parsearFecha(raw["fecha_final"]);
  if (!fechaInicio || !fechaFinal) return null;

  return {
    nombre: raw["nombre"] == null ? "Sin nombre" : String(raw["nombre"]),
    tipo:
      raw["tipo_evento"] == null ? "Evento" : String(raw["tipo_evento"]),
    descripcion:
      raw["descripcion"] == null ? "" : String(raw["descripcion"]),
    fechaInicio,
    fechaFinal,
  };
}

// Equivalente del GetxController para React Native; todavía no crea pantallas.
// El hook recibe el repositorio para seguir Clean Architecture.
export function useEventoController(repository: EventoRepository) {
  const [cargando, setCargando] = useState(false);
  const [eventos, setEventos] = useState<EventoUI[]>([]);
  const [error, setError] = useState<string | null>(null);

  const obtenerPorProyecto = useMemo(
    () => new GetEventosByProject(repository),
    [repository]
  );

  const cargarEventos = useCallback(
    async (idProyecto: number): Promise<void> => {
      setCargando(true);
      setError(null);

      try {
        const eventosRaw = await obtenerPorProyecto.execute(idProyecto);
        const lista = eventosRaw
          .map(mapearEvento)
          .filter((evento): evento is EventoUI => evento !== null)
          .sort((a, b) => a.fechaInicio.getTime() - b.fechaInicio.getTime());

        setEventos(lista);
      } catch (e) {
        setEventos([]);
        setError(e instanceof Error ? e.message : String(e));
        console.error("[EVENTO_CONTROLLER] Error cargando eventos:", e);
      } finally {
        setCargando(false);
      }
    },
    [obtenerPorProyecto]
  );

  return { cargando, eventos, error, cargarEventos };
}
