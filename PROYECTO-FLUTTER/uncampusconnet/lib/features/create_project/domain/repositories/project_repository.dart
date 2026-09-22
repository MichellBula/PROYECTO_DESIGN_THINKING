import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Map<String, dynamic>> createProject(
    Project project,
  );
}