import '../entities/convocatoria.dart';

abstract class ConvocatoriaRepository {
  Future<Map<String, dynamic>> createConvocatoria(
    Convocatoria convocatoria,
  );

  Future<Map<String, dynamic>?> getConvocatoriaByProject(
    int idProyecto,
  );
}