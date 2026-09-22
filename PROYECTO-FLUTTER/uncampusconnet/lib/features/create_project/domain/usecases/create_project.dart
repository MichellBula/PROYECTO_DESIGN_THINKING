import '../entities/project.dart';
import '../repositories/project_repository.dart';

class CreateProject {
  final ProjectRepository repository;

  CreateProject({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Project project,
  ) async {
    return await repository.createProject(
      project,
    );
  }
}