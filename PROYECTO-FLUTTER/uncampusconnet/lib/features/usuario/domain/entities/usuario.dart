class Usuario {
  final int idUsuario;
  final String nombreUsuario;
  final String correoInstitucional;
  final String carrera;
  final int semestre;
  final String idAutenticador;

  const Usuario({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.correoInstitucional,
    required this.carrera,
    required this.semestre,
    required this.idAutenticador,
  });
}