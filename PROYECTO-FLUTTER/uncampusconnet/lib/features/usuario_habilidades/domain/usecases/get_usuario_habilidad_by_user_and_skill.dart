import '../repositories/usuario_habilidades_repository.dart';

class GetUsuarioHabilidadByUserAndSkill {
  final UsuarioHabilidadesRepository repository;

  GetUsuarioHabilidadByUserAndSkill({
    required this.repository,
  });

  Future<Map<String, dynamic>?> call({
    required int idUsuario,
    required int idHabilidad,
  }) async {
    return await repository
        .getUsuarioHabilidadByUserAndSkill(
      idUsuario: idUsuario,
      idHabilidad: idHabilidad,
    );
  }
}