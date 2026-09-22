import '../../domain/entities/convocatoria.dart';
import '../../domain/repositories/convocatoria_repository.dart';
import '../../models/convocatoria_model.dart';
import '../datasources/convocatoria_remote_datasource.dart';

class ConvocatoriaRepositoryImpl
    implements ConvocatoriaRepository {
  final ConvocatoriaRemoteDatasource datasource;

  ConvocatoriaRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createConvocatoria(
    Convocatoria convocatoria,
  ) async {
    final model = ConvocatoriaModel.fromEntity(
      convocatoria,
    );

    return await datasource.createConvocatoria(
      model,
    );
  }

  @override
  Future<Map<String, dynamic>?> getConvocatoriaByProject(
    int idProyecto,
  ) {
    return datasource.getConvocatoriaByProject(
      idProyecto,
    );
  }
}