import '../repositories/solicitud_repository.dart';

class GetMisSolicitudes {
  final SolicitudRepository repository;

  GetMisSolicitudes({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call(
    int idUsuario,
  ) async {
    return await repository.getMisSolicitudes(
      idUsuario,
    );
  }
}