import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl
    implements ProfileRepository {
  final ProfileRemoteDatasource datasource;

  ProfileRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Profile?> getProfile(
    int idUsuario,
  ) {
    return datasource.getProfile(
      idUsuario,
    );
  }
}