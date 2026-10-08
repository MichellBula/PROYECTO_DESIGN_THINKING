import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Map<String, dynamic>> createProject(
    Project project,
  );

  Future<Map<String, dynamic>> calificarProyecto({
    required int idProyecto,
    required double calificacion,
  });
}