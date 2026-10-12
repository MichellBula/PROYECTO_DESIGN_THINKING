class Solicitud {
  final int idProyecto;
  final int idUsuario;
  final String estado;
  final DateTime fechaEnviada;
  final DateTime? fechaRespuesta;
  final int idProyectoRol;

  /// Motivo o comentario escrito por quien solicita
  /// participar en el proyecto.
  final String comentario;

  const Solicitud({
    required this.idProyecto,
    required this.idUsuario,
    required this.estado,
    required this.fechaEnviada,
    required this.fechaRespuesta,
    required this.idProyectoRol,
    this.comentario = '',
  });
}