import '../../domain/entities/project_role.dart';
import '../../domain/repositories/project_roles_repository.dart';
import '../../models/project_role_model.dart';
import '../datasources/project_roles_remote_datasource.dart';

class ProjectRolesRepositoryImpl
    implements ProjectRolesRepository {
  final ProjectRolesRemoteDatasource datasource;

  ProjectRolesRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createProjectRole(
    ProjectRole projectRole,
  ) async {
    final model = ProjectRoleModel.fromEntity(
      projectRole,
    );

    return await datasource.createProjectRole(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getRolesByProject(
    int idProyecto,
  ) {
    return datasource.getRolesByProject(
      idProyecto,
    );
  }
}