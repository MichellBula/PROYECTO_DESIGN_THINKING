import '../entities/solicitud.dart';

abstract class SolicitudRepository {
  Future<Map<String, dynamic>> createSolicitud(
    Solicitud solicitud,
  );

  Future<List<Map<String, dynamic>>> getMisSolicitudes(
    int idUsuario,
  );

  Future<List<Map<String, dynamic>>>
      getSolicitudesPendientesDeMisProyectos(
    int idUsuario,
  );

  Future<Map<String, dynamic>?> getSolicitudById(
    int idSolicitud,
  );

  Future<Map<String, dynamic>> responderSolicitud({
    required int idSolicitud,
    required String nuevoEstado,
  });

  Future<int> getIdUsuarioAutenticado();

  Future<int> getIdCreadorDelProyecto(
    int idProyecto,
  );

  Future<Map<String, dynamic>?> getProyectoRolById(
    int idProyectoRol,
  );
}