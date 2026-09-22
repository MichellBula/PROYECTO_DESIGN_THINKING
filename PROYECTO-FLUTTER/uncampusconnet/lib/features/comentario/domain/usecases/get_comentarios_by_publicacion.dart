import '../repositories/comentario_repository.dart';

class GetComentariosByPublicacion {
  final ComentarioRepository repository;

  GetComentariosByPublicacion({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idPublicacion,
  ) async {
    return await repository
        .getComentariosByPublicacion(
      idPublicacion,
    );
  }
}