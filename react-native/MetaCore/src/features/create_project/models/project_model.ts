import { Project } from "../domain/entities/project";
import type { RegistroRoble } from "../domain/entities/types";

export class ProjectModel extends Project {
  static fromEntity(p: Project): ProjectModel {
    return new ProjectModel(p.nombre, p.descripcion, p.idCreador, p.idCategoria,
      p.idTipoProyecto, p.objetivo, p.requisitos, p.numIntegrantes,
      p.docenteAsesor, p.estado, p.calificacion);
  }
  toMap(): RegistroRoble {
    const data: RegistroRoble = {
      nombre: this.nombre, descripcion: this.descripcion, id_creador: this.idCreador,
      id_categoria: this.idCategoria, id_tipo_proyecto: this.idTipoProyecto,
      objetivo: this.objetivo, requisitos: this.requisitos,
      num_integrantes: this.numIntegrantes, docente_asesor: this.docenteAsesor,
      estado: this.estado,
    };
    if (this.calificacion !== null) data.calificacion = this.calificacion;
    return data;
  }
}
