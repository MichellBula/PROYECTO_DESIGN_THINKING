import '../repositories/comentario_repository.dart';

class GetComentarioById {
  final ComentarioRepository repository;

  GetComentarioById({
    required this.repository,
  });

  Future<Map<String, dynamic>?> call(
    int idComentario,
  ) async {
    return await repository.getComentarioById(
      idComentario,
    );
  }
}