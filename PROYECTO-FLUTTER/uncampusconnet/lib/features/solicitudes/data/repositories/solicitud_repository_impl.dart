import '../../domain/entities/solicitud.dart';
import '../../domain/repositories/solicitud_repository.dart';
import '../../models/solicitud_model.dart';
import '../datasources/solicitud_remote_datasource.dart';

class SolicitudRepositoryImpl
    implements SolicitudRepository {
  final SolicitudRemoteDatasource datasource;

  SolicitudRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Map<String, dynamic>> createSolicitud(
    Solicitud solicitud,
  ) async {
    final model =
        SolicitudModel.fromEntity(
      solicitud,
    );

    return await datasource.createSolicitud(
      model,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getMisSolicitudes(
    int idUsuario,
  ) {
    return datasource.getMisSolicitudes(
      idUsuario,
    );
  }

  @override
  Future<List<Map<String, dynamic>>>
      getSolicitudesPendientesDeMisProyectos(
    int idUsuario,
  ) {
    return datasource
        .getSolicitudesPendientesDeMisProyectos(
      idUsuario,
    );
  }

  @override
  Future<Map<String, dynamic>?> getSolicitudById(
    int idSolicitud,
  ) {
    return datasource.getSolicitudById(
      idSolicitud,
    );
  }

  @override
  Future<Map<String, dynamic>> responderSolicitud({
    required int idSolicitud,
    required String nuevoEstado,
  }) {
    return datasource.responderSolicitud(
      idSolicitud: idSolicitud,
      nuevoEstado: nuevoEstado,
    );
  }

  @override
  Future<int> getIdUsuarioAutenticado() {
    return datasource.getIdUsuarioAutenticado();
  }

  @override
  Future<int> getIdCreadorDelProyecto(
    int idProyecto,
  ) {
    return datasource.getIdCreadorDelProyecto(
      idProyecto,
    );
  }

  @override
  Future<Map<String, dynamic>?>
      getProyectoRolById(
    int idProyectoRol,
  ) {
    return datasource.getProyectoRolById(
      idProyectoRol,
    );
  }
}