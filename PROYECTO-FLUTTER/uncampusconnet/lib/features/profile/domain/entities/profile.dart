class Profile {
  final int idUsuario;
  final String nombreUsuario;
  final String correoInstitucional;
  final String carrera;
  final String semestre;
  final List<String> habilidades;

  // =====================================================
  // ESTADISTICAS
  // =====================================================

  /// Cantidad de proyectos en los que participa.
  ///
  /// Es null cuando el usuario todavía no tiene proyectos.
  final int? numeroProyectos;

  /// Promedio de calificación de los proyectos del usuario.
  ///
  /// Es null cuando todavía no tiene proyectos calificados.
  final double? calificacionUsuario;

  const Profile({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.correoInstitucional,
    required this.carrera,
    required this.semestre,
    required this.habilidades,
    this.numeroProyectos,
    this.calificacionUsuario,
  });
}