import '../entities/project_role.dart';

abstract class ProjectRolesRepository {
  Future<Map<String, dynamic>> createProjectRole(
    ProjectRole projectRole,
  );

  Future<List<Map<String, dynamic>>> getRolesByProject(
    int idProyecto,
  );
}