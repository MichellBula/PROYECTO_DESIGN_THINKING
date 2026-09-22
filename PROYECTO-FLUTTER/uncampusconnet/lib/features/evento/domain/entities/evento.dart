class Evento {
  final int idProyecto;
  final String nombre;
  final String tipoEvento;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinal;

  const Evento({
    required this.idProyecto,
    required this.nombre,
    required this.tipoEvento,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFinal,
  });
}