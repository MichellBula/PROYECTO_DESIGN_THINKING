import '../entities/publicacion.dart';

abstract class PublicacionRepository {
  Future<Map<String, dynamic>> createPublicacion(
    Publicacion publicacion,
  );

  Future<List<Map<String, dynamic>>>
      getPublicacionesByProject(
    int idProyecto,
  );

  Future<Map<String, dynamic>?>
      getPublicacionById(
    int idPublicacion,
  );
}