import '../repositories/publicacion_repository.dart';

class GetPublicacionesByProject {
  final PublicacionRepository repository;

  GetPublicacionesByProject({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idProyecto,
  ) async {
    return await repository
        .getPublicacionesByProject(
      idProyecto,
    );
  }
}