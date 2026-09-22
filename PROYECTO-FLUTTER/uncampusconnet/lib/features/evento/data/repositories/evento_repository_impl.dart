import '../../domain/entities/evento.dart';
import '../../domain/repositories/evento_repository.dart';
import '../../models/evento_model.dart';
import '../datasources/evento_remote_datasource.dart';

class EventoRepositoryImpl
    implements EventoRepository {
  final EventoRemoteDatasource datasource;

  EventoRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createEvento(
    Evento evento,
  ) async {
    final model =
        EventoModel.fromEntity(
      evento,
    );

    return await datasource.createEvento(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getEventosByProject(
    int idProyecto,
  ) {
    return datasource.getEventosByProject(
      idProyecto,
    );
  }

  @override
  Future<Map<String, dynamic>?> getEventoById(
    int idEvento,
  ) {
    return datasource.getEventoById(
      idEvento,
    );
  }
}