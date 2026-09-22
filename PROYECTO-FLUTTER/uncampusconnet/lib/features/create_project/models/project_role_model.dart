import '../domain/entities/project_role.dart';

class ProjectRoleModel extends ProjectRole {
  const ProjectRoleModel({
    required super.idProyecto,
    required super.idRol,
    required super.cantidad,
  });

  factory ProjectRoleModel.fromEntity(
    ProjectRole projectRole,
  ) {
    return ProjectRoleModel(
      idProyecto: projectRole.idProyecto,
      idRol: projectRole.idRol,
      cantidad: projectRole.cantidad,
    );
  }

  Map<String, dynamic> toMap({
    required int idProyectoRol,
  }) {
    return {
      'id_proyecto_rol': idProyectoRol,
      'id_proyecto': idProyecto,
      'id_rol': idRol,
      'cantidad': cantidad,
    };
  }
}