import 'package:uncampusconnet/features/etapa/data/datasource/etapa_remote_datasource.dart';

import '../../domain/entities/etapa.dart';
import '../../domain/repositories/etapa_repository.dart';
import '../../models/etapa_model.dart';

class EtapaRepositoryImpl implements EtapaRepository {
  final EtapaRemoteDatasource datasource;

  EtapaRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createEtapa(
    Etapa etapa,
  ) async {
    final model = EtapaModel.fromEntity(
      etapa,
    );

    return datasource.createEtapa(
      model,
    );
  }

  @override
  Future<Map<String, dynamic>?> getEtapaById(
    int idEtapa,
  ) {
    return datasource.getEtapaById(
      idEtapa,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getEtapasByProject(
    int idProyecto,
  ) {
    return datasource.getEtapasByProject(
      idProyecto,
    );
  }
}