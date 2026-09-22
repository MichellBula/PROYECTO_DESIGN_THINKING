import '../repositories/evento_repository.dart';

class GetEventoById {
  final EventoRepository repository;

  GetEventoById({
    required this.repository,
  });

  Future<Map<String, dynamic>?> call(
    int idEvento,
  ) async {
    return await repository.getEventoById(
      idEvento,
    );
  }
}