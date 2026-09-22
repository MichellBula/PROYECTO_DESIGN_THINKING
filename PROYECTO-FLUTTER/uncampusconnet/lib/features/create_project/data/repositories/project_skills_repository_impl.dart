import '../../domain/entities/project_skill.dart';
import '../../domain/repositories/project_skills_repository.dart';
import '../../models/project_skill_model.dart';
import '../datasources/project_skills_remote_datasource.dart';

class ProjectSkillsRepositoryImpl
    implements ProjectSkillsRepository {
  final ProjectSkillsRemoteDatasource datasource;

  ProjectSkillsRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createProjectSkill(
    ProjectSkill projectSkill,
  ) async {
    final model = ProjectSkillModel.fromEntity(
      projectSkill,
    );

    return await datasource.createProjectSkill(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getSkillsByProject(
    int idProyecto,
  ) {
    return datasource.getSkillsByProject(
      idProyecto,
    );
  }
}