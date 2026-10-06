import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetMyProfile {
  final ProfileRepository repository;

  GetMyProfile({
    required this.repository,
  });

  Future<Profile?> call(
    int idUsuario,
  ) async {
    return await repository.getProfile(
      idUsuario,
    );
  }
}