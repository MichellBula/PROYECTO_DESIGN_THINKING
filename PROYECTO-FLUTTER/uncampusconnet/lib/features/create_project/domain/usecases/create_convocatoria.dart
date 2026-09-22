import '../entities/convocatoria.dart';
import '../repositories/convocatoria_repository.dart';

class CreateConvocatoria {
  final ConvocatoriaRepository repository;

  CreateConvocatoria({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Convocatoria convocatoria,
  ) async {
    return await repository.createConvocatoria(
      convocatoria,
    );
  }
}