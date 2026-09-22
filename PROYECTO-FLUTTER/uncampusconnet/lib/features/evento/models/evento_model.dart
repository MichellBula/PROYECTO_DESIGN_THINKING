import '../domain/entities/evento.dart';

class EventoModel extends Evento {
  const EventoModel({
    required super.idProyecto,
    required super.nombre,
    required super.tipoEvento,
    required super.descripcion,
    required super.fechaInicio,
    required super.fechaFinal,
  });

  factory EventoModel.fromEntity(
    Evento evento,
  ) {
    return EventoModel(
      idProyecto: evento.idProyecto,
      nombre: evento.nombre,
      tipoEvento: evento.tipoEvento,
      descripcion: evento.descripcion,
      fechaInicio: evento.fechaInicio,
      fechaFinal: evento.fechaFinal,
    );
  }

  Map<String, dynamic> toMap({
    required int idEvento,
  }) {
    return {
      'id_evento': idEvento,
      'id_proyecto': idProyecto,
      'nombre': nombre,
      'tipo_evento': tipoEvento,
      'descripcion': descripcion,
      'fecha_inicio': fechaInicio
          .toUtc()
          .toIso8601String(),
      'fecha_final': fechaFinal
          .toUtc()
          .toIso8601String(),
    };
  }
}