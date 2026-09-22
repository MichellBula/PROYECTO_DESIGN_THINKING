import '../repositories/usuario_habilidades_repository.dart';

class GetHabilidadesByUser {
  final UsuarioHabilidadesRepository repository;

  GetHabilidadesByUser({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idUsuario,
  ) async {
    return await repository.getHabilidadesByUser(
      idUsuario,
    );
  }
}