import '../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.nombre,
    required super.descripcion,
    required super.idCreador,
    required super.idCategoria,
    required super.idTipoProyecto,
    required super.objetivo,
    required super.requisitos,
    required super.numIntegrantes,
    required super.docenteAsesor,
    required super.estado,
  });

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      nombre: project.nombre,
      descripcion: project.descripcion,
      idCreador: project.idCreador,
      idCategoria: project.idCategoria,
      idTipoProyecto: project.idTipoProyecto,
      objetivo: project.objetivo,
      requisitos: project.requisitos,
      numIntegrantes: project.numIntegrantes,
      docenteAsesor: project.docenteAsesor,
      estado: project.estado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'id_creador': idCreador,
      'id_categoria': idCategoria,
      'id_tipo_proyecto': idTipoProyecto,
      'objetivo': objetivo,
      'requisitos': requisitos,
      'num_integrantes': numIntegrantes,
      'docente_asesor': docenteAsesor,
      'estado': estado,
    };
  }
}