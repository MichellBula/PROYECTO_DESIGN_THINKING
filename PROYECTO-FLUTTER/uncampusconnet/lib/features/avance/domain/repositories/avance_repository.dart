import '../entities/avance.dart';

abstract class AvanceRepository {
  Future<Map<String, dynamic>> createAvance(
    Avance avance,
  );

  Future<Map<String, dynamic>?> getAvanceById(
    int idAvance,
  );

  Future<List<Map<String, dynamic>>> getAvancesByEtapa(
    int idEtapa,
  );

  Future<List<Map<String, dynamic>>> getAvancesByProject(
    int idProyecto,
  );

  Future<int> getPorcentajeByEtapa(
    int idEtapa,
  );
}