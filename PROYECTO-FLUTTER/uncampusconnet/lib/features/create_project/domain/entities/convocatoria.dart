class Convocatoria {
  final int idProyecto;
  final DateTime fechaInicio;
  final DateTime fechaFinal;
  final bool estado;
  final DateTime? fechaLimiteDeAbandono;

  const Convocatoria({
    required this.idProyecto,
    required this.fechaInicio,
    required this.fechaFinal,
    required this.estado,
    required this.fechaLimiteDeAbandono,
  });
}