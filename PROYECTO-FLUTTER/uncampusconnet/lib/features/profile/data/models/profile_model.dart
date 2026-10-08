import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.idUsuario,
    required super.nombreUsuario,
    required super.correoInstitucional,
    required super.carrera,
    required super.semestre,
    required super.habilidades,
    super.numeroProyectos,
    super.calificacionUsuario,
  });

  factory ProfileModel.fromEntity(
    Profile profile,
  ) {
    return ProfileModel(
      idUsuario: profile.idUsuario,
      nombreUsuario: profile.nombreUsuario,
      correoInstitucional:
          profile.correoInstitucional,
      carrera: profile.carrera,
      semestre: profile.semestre,
      habilidades: profile.habilidades,
      numeroProyectos:
          profile.numeroProyectos,
      calificacionUsuario:
          profile.calificacionUsuario,
    );
  }
}