import '../entities/integrante.dart';

abstract class IntegranteRepository {
  Future<Map<String, dynamic>> createIntegrante(
    Integrante integrante,
  );

  Future<List<Map<String, dynamic>>>
      getIntegrantesByProject(
    int idProyecto,
  );

  Future<Map<String, dynamic>?>
      getIntegranteByUserAndProject({
    required int idUsuario,
    required int idProyecto,
  });
}