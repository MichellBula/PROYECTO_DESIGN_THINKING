import '../entities/project_skill.dart';
import '../repositories/project_skills_repository.dart';

class CreateProjectSkill {
  final ProjectSkillsRepository repository;

  CreateProjectSkill({required this.repository});

  Future<Map<String, dynamic>> call(ProjectSkill projectSkill) async {
    return await repository.createProjectSkill(projectSkill);
  }
}
