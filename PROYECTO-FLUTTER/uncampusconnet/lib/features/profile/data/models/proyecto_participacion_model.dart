class ProyectoParticipacion {
  final int idProyecto;
  final String nombre;
  final String descripcion;
  final String estado;
  final String rol;

  const ProyectoParticipacion({
    required this.idProyecto,
    required this.nombre,
    required this.descripcion,
    required this.estado,
    required this.rol,
  });

  /// Texto del chip.
  String get estadoLabel {
    switch (estado.toLowerCase().trim()) {
      case 'activo':
        return 'En proceso';
      case 'finalizado':
        return 'Finalizado';
      default:
        return estado;
    }
  }
}