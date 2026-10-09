import '../entities/etapa.dart';

abstract class EtapaRepository {
  Future<Map<String, dynamic>> createEtapa(
    Etapa etapa,
  );

  Future<Map<String, dynamic>?> getEtapaById(
    int idEtapa,
  );

  Future<List<Map<String, dynamic>>> getEtapasByProject(
    int idProyecto,
  );
}