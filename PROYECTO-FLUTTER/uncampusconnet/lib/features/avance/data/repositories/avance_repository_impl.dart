import '../../domain/entities/avance.dart';
import '../../domain/repositories/avance_repository.dart';
import '../../models/avance_model.dart';
import '../datasources/avance_remote_datasource.dart';

class AvanceRepositoryImpl implements AvanceRepository {
  final AvanceRemoteDatasource datasource;

  AvanceRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createAvance(
    Avance avance,
  ) async {
    final model = AvanceModel.fromEntity(
      avance,
    );

    return datasource.createAvance(
      model,
    );
  }

  @override
  Future<Map<String, dynamic>?> getAvanceById(
    int idAvance,
  ) {
    return datasource.getAvanceById(
      idAvance,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAvancesByEtapa(
    int idEtapa,
  ) {
    return datasource.getAvancesByEtapa(
      idEtapa,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAvancesByProject(
    int idProyecto,
  ) {
    return datasource.getAvancesByProject(
      idProyecto,
    );
  }

  @override
  Future<int> getPorcentajeByEtapa(
    int idEtapa,
  ) {
    return datasource.getPorcentajeByEtapa(
      idEtapa,
    );
  }
}