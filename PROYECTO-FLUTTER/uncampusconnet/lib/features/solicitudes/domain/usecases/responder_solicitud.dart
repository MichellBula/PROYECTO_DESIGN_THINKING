import '../repositories/solicitud_repository.dart';

class ResponderSolicitud {
  final SolicitudRepository repository;

  ResponderSolicitud({
    required this.repository,
  });

  Future<Map<String, dynamic>> call({
    required int idSolicitud,
    required String nuevoEstado,
  }) async {
    return await repository.responderSolicitud(
      idSolicitud: idSolicitud,
      nuevoEstado: nuevoEstado,
    );
  }
}