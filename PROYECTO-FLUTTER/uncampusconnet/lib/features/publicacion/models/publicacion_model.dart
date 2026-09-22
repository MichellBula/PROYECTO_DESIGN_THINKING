import '../domain/entities/publicacion.dart';

class PublicacionModel extends Publicacion {
  const PublicacionModel({
    required super.idProyecto,
    required super.titulo,
    required super.contenido,
    required super.fechaPublicacion,
  });

  factory PublicacionModel.fromEntity(
    Publicacion publicacion,
  ) {
    return PublicacionModel(
      idProyecto: publicacion.idProyecto,
      titulo: publicacion.titulo,
      contenido: publicacion.contenido,
      fechaPublicacion:
          publicacion.fechaPublicacion,
    );
  }

  Map<String, dynamic> toMap({
    required int idPublicacion,
  }) {
    return {
      'id_publicacion': idPublicacion,
      'id_proyecto': idProyecto,
      'titulo': titulo,
      'contenido': contenido,
      'fecha_publicacion':
          fechaPublicacion
              .toUtc()
              .toIso8601String(),
    };
  }
}