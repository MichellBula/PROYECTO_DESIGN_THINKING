import { useCallback, useMemo, useState } from "react";

import type { IntegranteRepository } from "../domain/repositories/integrante_repository";
import { GetParticipantesByProject } from "../domain/usecases/get_participantes_by_project";

export interface Participante {
  usuario: string;
  rol: string;
}

// Sustituto del GetxController: se usará dentro de una futura pantalla.
export function useIntegranteController(repository: IntegranteRepository) {
  const [cargando, setCargando] = useState(false);
  const [participantes, setParticipantes] = useState<Participante[]>([]);
  const [error, setError] = useState<string | null>(null);

  const obtenerParticipantes = useMemo(
    () => new GetParticipantesByProject(repository),
    [repository]
  );

  const cargarParticipantes = useCallback(
    async (idProyecto: number): Promise<void> => {
      setCargando(true);
      setError(null);

      try {
        const lista = await obtenerParticipantes.execute(idProyecto);
        setParticipantes(
          lista.map((item) => ({
            usuario: `@${item.nombreUsuario}`,
            rol: item.nombreRol,
          }))
        );
      } catch (e) {
        setParticipantes([]);
        setError(e instanceof Error ? e.message : String(e));
        console.error("[INTEGRANTE_CONTROLLER] Error cargando participantes:", e);
      } finally {
        setCargando(false);
      }
    },
    [obtenerParticipantes]
  );

  return { cargando, participantes, error, cargarParticipantes };
}
