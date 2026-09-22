import '../entities/usuario_habilidad.dart';

abstract class UsuarioHabilidadesRepository {
  Future<Map<String, dynamic>>
      createUsuarioHabilidad(
    UsuarioHabilidad usuarioHabilidad,
  );

  Future<List<Map<String, dynamic>>>
      getHabilidadesByUser(
    int idUsuario,
  );

  Future<Map<String, dynamic>?>
      getUsuarioHabilidadByUserAndSkill({
    required int idUsuario,
    required int idHabilidad,
  });
}