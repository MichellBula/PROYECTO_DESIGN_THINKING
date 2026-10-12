import '../entities/profile.dart';
import '../../data/models/proyecto_participacion_model.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile(
    int idUsuario,
  );

  Future<List<ProyectoParticipacion>> getProyectosParticipados(
    int idUsuario,
  );
}