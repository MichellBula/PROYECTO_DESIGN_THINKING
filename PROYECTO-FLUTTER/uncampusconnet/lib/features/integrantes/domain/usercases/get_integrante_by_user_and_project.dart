import '../repositories/integrante_repository.dart';

class GetIntegranteByUserAndProject {
  final IntegranteRepository repository;

  GetIntegranteByUserAndProject({
    required this.repository,
  });

  Future<Map<String, dynamic>?> call({
    required int idUsuario,
    required int idProyecto,
  }) async {
    return await repository.getIntegranteByUserAndProject(
      idUsuario: idUsuario,
      idProyecto: idProyecto,
    );
  }
}