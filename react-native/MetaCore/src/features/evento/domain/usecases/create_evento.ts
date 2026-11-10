import type { Evento, RegistroEvento } from "../entities/evento";
import type { EventoRepository } from "../repositories/evento_repository";

export class CreateEvento {
  constructor(private readonly repository: EventoRepository) {}

  execute(evento: Evento): Promise<RegistroEvento> {
    return this.repository.createEvento(evento);
  }
}
