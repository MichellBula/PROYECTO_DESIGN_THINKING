import type { Evento, RegistroEvento } from "../entities/evento";

// Contrato del dominio. La implementación concreta vive en data/.
export interface EventoRepository {
  createEvento(evento: Evento): Promise<RegistroEvento>;
  getEventosByProject(idProyecto: number): Promise<RegistroEvento[]>;
  getEventoById(idEvento: number): Promise<RegistroEvento | null>;
}
