import '../entities/comentario.dart';

abstract class ComentarioRepository {
  Future<Map<String, dynamic>> createComentario(
    Comentario comentario,
  );

  Future<List<Map<String, dynamic>>>
      getComentariosByPublicacion(
    int idPublicacion,
  );

  Future<Map<String, dynamic>?> getComentarioById(
    int idComentario,
  );
}