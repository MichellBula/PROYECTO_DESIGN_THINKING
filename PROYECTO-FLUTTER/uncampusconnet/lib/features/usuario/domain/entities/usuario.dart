class Usuario {
  final int idUsuario;
  final String nombreUsuario;
  final String correoInstitucional;
  final String carrera;
  final int semestre;
  final String idAutenticador;

  /// Cantidad de proyectos en los que ha participado.
  ///
  /// Es null cuando el usuario todavía no tiene proyectos.
  final int? numeroProyectos;

  /// Promedio de calificación de los proyectos
  /// en los que ha participado.
  ///
  /// Es null cuando no tiene proyectos calificados.
  final double? calificacionUsuario;

  const Usuario({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.correoInstitucional,
    required this.carrera,
    required this.semestre,
    required this.idAutenticador,
    this.numeroProyectos,
    this.calificacionUsuario,
  });
}