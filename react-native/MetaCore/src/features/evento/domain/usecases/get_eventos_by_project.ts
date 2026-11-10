import type { RegistroEvento } from "../entities/evento";
import type { EventoRepository } from "../repositories/evento_repository";

export class GetEventosByProject {
  constructor(private readonly repository: EventoRepository) {}

  execute(idProyecto: number): Promise<RegistroEvento[]> {
    return this.repository.getEventosByProject(idProyecto);
  }
}
