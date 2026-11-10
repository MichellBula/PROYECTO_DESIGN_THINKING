import { Publicacion } from "../domain/entities/publicacion";

// Adapta la entidad al esquema de columnas de la tabla `publicacion`.
export class PublicacionModel extends Publicacion {
  static fromEntity(publicacion: Publicacion): PublicacionModel {
    return new PublicacionModel(
      publicacion.idProyecto,
      publicacion.titulo,
      publicacion.contenido,
      publicacion.fechaPublicacion
    );
  }

  toMap({ idPublicacion }: { idPublicacion: number }): Record<string, string | number> {
    return {
      id_publicacion: idPublicacion,
      id_proyecto: this.idProyecto,
      titulo: this.titulo,
      contenido: this.contenido,
      fecha_publicacion: this.fechaPublicacion.toISOString(),
    };
  }
}
