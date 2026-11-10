import type { RegistroEvento } from "../entities/evento";
import type { EventoRepository } from "../repositories/evento_repository";

export class GetEventoById {
  constructor(private readonly repository: EventoRepository) {}

  execute(idEvento: number): Promise<RegistroEvento | null> {
    return this.repository.getEventoById(idEvento);
  }
}
