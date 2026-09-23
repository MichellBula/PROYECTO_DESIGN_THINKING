import 'package:uncampusconnet/features/create_project/domain/entities/project_skill.dart';

class ProjectSkillModel extends ProjectSkill {
  const ProjectSkillModel({
    required super.idProyecto,
    required super.idHabilidad,
  });

  factory ProjectSkillModel.fromEntity(ProjectSkill projectSkill) {
    return ProjectSkillModel(
      idProyecto: projectSkill.idProyecto,
      idHabilidad: projectSkill.idHabilidad,
    );
  }

  Map<String, dynamic> toMap({required int idProyectoHabilidad}) {
    return {
      'id_proyecto_habilidad': idProyectoHabilidad,
      'id_proyecto': idProyecto,
      'id_habilidad': idHabilidad,
    };
  }
}
