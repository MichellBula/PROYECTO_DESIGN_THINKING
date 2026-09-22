import '../repositories/solicitud_repository.dart';

class GetSolicitudesPendientes {
  final SolicitudRepository repository;

  GetSolicitudesPendientes({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idUsuario,
  ) async {
    return await repository
        .getSolicitudesPendientesDeMisProyectos(
      idUsuario,
    );
  }
}