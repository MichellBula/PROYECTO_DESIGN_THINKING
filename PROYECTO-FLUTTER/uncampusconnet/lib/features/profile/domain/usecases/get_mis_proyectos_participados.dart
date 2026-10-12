import '../../data/models/proyecto_participacion_model.dart';
import '../repositories/profile_repository.dart';

class GetMisProyectosParticipados {
  final ProfileRepository repository;

  GetMisProyectosParticipados({
    required this.repository,
  });

  Future<List<ProyectoParticipacion>> call(
    int idUsuario,
  ) async {
    return await repository.getProyectosParticipados(idUsuario);
  }
}