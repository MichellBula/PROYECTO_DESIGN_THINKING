import '../repositories/publicacion_repository.dart';

class GetTodasLasPublicaciones {
  final PublicacionRepository repository;

  GetTodasLasPublicaciones({
    required this.repository,
  });

  Future<List<Map<String, dynamic>>> call() async {
    return await repository.getTodasLasPublicaciones();
  }
}