import '../../domain/entities/publicacion.dart';
import '../../domain/repositories/publicacion_repository.dart';
import '../../models/publicacion_model.dart';
import '../datasources/publicacion_remote_datasource.dart';

class PublicacionRepositoryImpl
    implements PublicacionRepository {
  final PublicacionRemoteDatasource datasource;

  PublicacionRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createPublicacion(
    Publicacion publicacion,
  ) async {
    final model =
        PublicacionModel.fromEntity(
      publicacion,
    );

    return await datasource.createPublicacion(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>>
      getPublicacionesByProject(
    int idProyecto,
  ) {
    return datasource.getPublicacionesByProject(
      idProyecto,
    );
  }

  @override
  Future<Map<String, dynamic>?>
      getPublicacionById(
    int idPublicacion,
  ) {
    return datasource.getPublicacionById(
      idPublicacion,
    );
  }
}