import '../../domain/entities/usuario_habilidad.dart';
import '../../domain/repositories/usuario_habilidades_repository.dart';
import '../../models/usuario_habilidad_model.dart';
import '../datasources/usuario_habilidades_remote_datasource.dart';

class UsuarioHabilidadesRepositoryImpl
    implements UsuarioHabilidadesRepository {
  final UsuarioHabilidadesRemoteDatasource datasource;

  UsuarioHabilidadesRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>>
      createUsuarioHabilidad(
    UsuarioHabilidad usuarioHabilidad,
  ) async {
    final model =
        UsuarioHabilidadModel.fromEntity(
      usuarioHabilidad,
    );

    return await datasource
        .createUsuarioHabilidad(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>>
      getHabilidadesByUser(
    int idUsuario,
  ) {
    return datasource.getHabilidadesByUser(
      idUsuario,
    );
  }

  @override
  Future<Map<String, dynamic>?>
      getUsuarioHabilidadByUserAndSkill({
    required int idUsuario,
    required int idHabilidad,
  }) {
    return datasource
        .getUsuarioHabilidadByUserAndSkill(
      idUsuario: idUsuario,
      idHabilidad: idHabilidad,
    );
  }
}