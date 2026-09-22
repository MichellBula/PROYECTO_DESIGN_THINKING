import '../../domain/entities/integrante.dart';
import '../../domain/repositories/integrante_repository.dart';
import '../../models/integrante_model.dart';
import '../datasources/integrante_remote_datasource.dart';

class IntegranteRepositoryImpl
    implements IntegranteRepository {
  final IntegranteRemoteDatasource datasource;

  IntegranteRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createIntegrante(
    Integrante integrante,
  ) async {
    final model =
        IntegranteModel.fromEntity(
      integrante,
    );

    return await datasource.createIntegrante(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>>
      getIntegrantesByProject(
    int idProyecto,
  ) {
    return datasource.getIntegrantesByProject(
      idProyecto,
    );
  }

  @override
  Future<Map<String, dynamic>?>
      getIntegranteByUserAndProject({
    required int idUsuario,
    required int idProyecto,
  }) {
    return datasource.getIntegranteByUserAndProject(
      idUsuario: idUsuario,
      idProyecto: idProyecto,
    );
  }
}