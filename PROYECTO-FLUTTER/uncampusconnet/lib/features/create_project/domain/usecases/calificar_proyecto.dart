import '../repositories/project_repository.dart';

class CalificarProyecto {
  final ProjectRepository repository;

  CalificarProyecto({
    required this.repository,
  });

  Future<Map<String, dynamic>> call({
    required int idProyecto,
    required double calificacion,
  }) async {
    return await repository.calificarProyecto(
      idProyecto: idProyecto,
      calificacion: calificacion,
    );
  }
}