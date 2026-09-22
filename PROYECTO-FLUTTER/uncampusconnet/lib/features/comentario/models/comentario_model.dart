import '../domain/entities/comentario.dart';

class ComentarioModel extends Comentario {
  const ComentarioModel({
    required super.idPublicacion,
    required super.idUsuario,
    required super.contenido,
    required super.fechaComentario,
  });

  factory ComentarioModel.fromEntity(
    Comentario comentario,
  ) {
    return ComentarioModel(
      idPublicacion: comentario.idPublicacion,
      idUsuario: comentario.idUsuario,
      contenido: comentario.contenido,
      fechaComentario: comentario.fechaComentario,
    );
  }

  Map<String, dynamic> toMap({
    required int idComentario,
  }) {
    return {
      'id_comentario': idComentario,
      'id_publicacion': idPublicacion,
      'id_usuario': idUsuario,
      'contenido': contenido,
      'fecha_comentario': fechaComentario
          .toUtc()
          .toIso8601String(),
    };
  }
}