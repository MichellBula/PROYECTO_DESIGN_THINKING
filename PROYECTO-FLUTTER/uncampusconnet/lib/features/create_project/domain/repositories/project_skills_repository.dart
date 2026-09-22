import '../entities/project_skill.dart';

abstract class ProjectSkillsRepository {
  Future<Map<String, dynamic>> createProjectSkill(
    ProjectSkill projectSkill,
  );

  Future<List<Map<String, dynamic>>> getSkillsByProject(
    int idProyecto,
  );
}