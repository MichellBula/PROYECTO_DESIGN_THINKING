import '../domain/entities/solicitud.dart';

class SolicitudModel extends Solicitud {
  const SolicitudModel({
    required super.idProyecto,
    required super.idUsuario,
    required super.estado,
    required super.fechaEnviada,
    required super.fechaRespuesta,
    required super.idProyectoRol,
  });

  factory SolicitudModel.fromEntity(
    Solicitud solicitud,
  ) {
    return SolicitudModel(
      idProyecto: solicitud.idProyecto,
      idUsuario: solicitud.idUsuario,
      estado: solicitud.estado,
      fechaEnviada: solicitud.fechaEnviada,
      fechaRespuesta: solicitud.fechaRespuesta,
      idProyectoRol: solicitud.idProyectoRol,
    );
  }

  Map<String, dynamic> toMap({
    required int idSolicitud,
  }) {
    return {
      'id_solicitud': idSolicitud,
      'id_proyecto': idProyecto,
      'id_usuario': idUsuario,
      'estado': estado,
      'fecha_enviada': fechaEnviada
          .toUtc()
          .toIso8601String(),
      'fecha_respuesta': fechaRespuesta
          ?.toUtc()
          .toIso8601String(),
      'id_proyecto_rol': idProyectoRol,
    };
  }
}