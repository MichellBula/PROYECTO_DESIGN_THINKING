class Profile {
  final int idUsuario;
  final String nombreUsuario;
  final String correoInstitucional;
  final String carrera;
  final String semestre;
  final List<String> habilidades;

  const Profile({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.correoInstitucional,
    required this.carrera,
    required this.semestre,
    required this.habilidades,
  });
}