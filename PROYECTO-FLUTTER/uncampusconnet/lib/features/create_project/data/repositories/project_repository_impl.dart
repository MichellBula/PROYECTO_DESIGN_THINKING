import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../../models/project_model.dart';
import '../datasources/project_remote_datasource.dart';

class ProjectRepositoryImpl
    implements ProjectRepository {
  final ProjectRemoteDatasource datasource;

  ProjectRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createProject(
    Project project,
  ) async {
    final ProjectModel model =
        ProjectModel.fromEntity(project);

    return await datasource.createProject(
      model,
    );
  }
}