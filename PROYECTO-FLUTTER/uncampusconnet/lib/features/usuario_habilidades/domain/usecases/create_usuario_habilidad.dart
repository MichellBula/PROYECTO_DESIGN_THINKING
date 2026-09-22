import '../entities/usuario_habilidad.dart';
import '../repositories/usuario_habilidades_repository.dart';

class CreateUsuarioHabilidad {
  final UsuarioHabilidadesRepository repository;

  CreateUsuarioHabilidad({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    UsuarioHabilidad usuarioHabilidad,
  ) async {
    return await repository
        .createUsuarioHabilidad(
      usuarioHabilidad,
    );
  }
}