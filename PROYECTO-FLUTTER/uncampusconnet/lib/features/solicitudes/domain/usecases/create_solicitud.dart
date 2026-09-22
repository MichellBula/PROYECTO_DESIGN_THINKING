import '../entities/solicitud.dart';
import '../repositories/solicitud_repository.dart';

class CreateSolicitud {
  final SolicitudRepository repository;

  CreateSolicitud({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Solicitud solicitud,
  ) async {
    return await repository.createSolicitud(
      solicitud,
    );
  }
}