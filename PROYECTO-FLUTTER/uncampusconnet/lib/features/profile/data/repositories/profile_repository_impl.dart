import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/proyecto_participacion_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource datasource;

  ProfileRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Profile?> getProfile(
    int idUsuario,
  ) {
    return datasource.getProfile(idUsuario);
  }

  @override
  Future<List<ProyectoParticipacion>> getProyectosParticipados(
    int idUsuario,
  ) {
    return datasource.getProyectosParticipados(idUsuario);
  }
}