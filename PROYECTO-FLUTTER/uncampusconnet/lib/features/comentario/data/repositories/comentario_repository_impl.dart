import '../../domain/entities/comentario.dart';
import '../../domain/repositories/comentario_repository.dart';
import '../../models/comentario_model.dart';
import '../datasources/comentario_remote_datasource.dart';

class ComentarioRepositoryImpl
    implements ComentarioRepository {
  final ComentarioRemoteDatasource datasource;

  ComentarioRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createComentario(
    Comentario comentario,
  ) async {
    final model =
        ComentarioModel.fromEntity(
      comentario,
    );

    return await datasource.createComentario(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>>
      getComentariosByPublicacion(
    int idPublicacion,
  ) {
    return datasource.getComentariosByPublicacion(
      idPublicacion,
    );
  }

  @override
  Future<Map<String, dynamic>?>
      getComentarioById(
    int idComentario,
  ) {
    return datasource.getComentarioById(
      idComentario,
    );
  }
}