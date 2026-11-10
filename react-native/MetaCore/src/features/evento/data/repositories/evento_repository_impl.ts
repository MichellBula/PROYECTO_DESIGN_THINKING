import type { Evento, RegistroEvento } from "../../domain/entities/evento";
import type { EventoRepository } from "../../domain/repositories/evento_repository";
import { EventoModel } from "../../models/evento_model";
import { EventoRemoteDatasource } from "../datasources/evento_remote_datasource";

export class EventoRepositoryImpl implements EventoRepository {
  constructor(private readonly datasource: EventoRemoteDatasource) {}

  createEvento(evento: Evento): Promise<RegistroEvento> {
    return this.datasource.createEvento(EventoModel.fromEntity(evento));
  }

  getEventosByProject(idProyecto: number): Promise<RegistroEvento[]> {
    return this.datasource.getEventosByProject(idProyecto);
  }

  getEventoById(idEvento: number): Promise<RegistroEvento | null> {
    return this.datasource.getEventoById(idEvento);
  }
}
