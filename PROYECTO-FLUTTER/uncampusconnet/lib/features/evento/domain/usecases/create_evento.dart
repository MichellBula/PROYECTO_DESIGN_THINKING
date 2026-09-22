import '../entities/evento.dart';
import '../repositories/evento_repository.dart';

class CreateEvento {
  final EventoRepository repository;

  CreateEvento({
    required this.repository,
  });

  Future<Map<String, dynamic>> call(
    Evento evento,
  ) async {
    return await repository.createEvento(
      evento,
    );
  }
}