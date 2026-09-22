import '../entities/comentario.dart';
import '../repositories/comentario_repository.dart';

class CreateComentario {
  final ComentarioRepository repository;

  CreateComentario({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Comentario comentario,
  ) async {
    return await repository.createComentario(
      comentario,
    );
  }
}