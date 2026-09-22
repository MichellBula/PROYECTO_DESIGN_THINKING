import '../../../integrantes/domain/entities/integrante.dart';
import '../../../integrantes/domain/repositories/integrante_repository.dart';
import '../repositories/solicitud_repository.dart';

class AceptarSolicitud {
  final SolicitudRepository solicitudRepository;
  final IntegranteRepository integranteRepository;

  AceptarSolicitud({
    required this.solicitudRepository,
    required this.integranteRepository,
  });

  Future<Map<String, dynamic>> call(
    int idSolicitud,
  ) async {
    // =====================================================
    // 1. OBTENER SOLICITUD
    // =====================================================

    final solicitud =
        await solicitudRepository.getSolicitudById(
      idSolicitud,
    );

    if (solicitud == null) {
      throw Exception(
        'No existe la solicitud con id $idSolicitud.',
      );
    }

    final estadoActual =
        solicitud['estado']
            ?.toString()
            .toLowerCase();

    if (estadoActual != 'pendiente') {
      throw Exception(
        'Solo se pueden aceptar solicitudes pendientes.',
      );
    }

    // =====================================================
    // 2. OBTENER DATOS DE LA SOLICITUD
    // =====================================================

    final idProyecto = int.tryParse(
      solicitud['id_proyecto'].toString(),
    );

    final idUsuario = int.tryParse(
      solicitud['id_usuario'].toString(),
    );

    final idProyectoRol = int.tryParse(
      solicitud['id_proyecto_rol'].toString(),
    );

    if (
      idProyecto == null ||
      idUsuario == null ||
      idProyectoRol == null
    ) {
      throw Exception(
        'La solicitud tiene datos inválidos.',
      );
    }

    // =====================================================
    // 3. VERIFICAR QUE EL USUARIO AUTENTICADO
    //    ES EL CREADOR
    // =====================================================

    final idUsuarioAutenticado =
        await solicitudRepository
            .getIdUsuarioAutenticado();

    final idCreador =
        await solicitudRepository
            .getIdCreadorDelProyecto(
      idProyecto,
    );

    if (idUsuarioAutenticado != idCreador) {
      throw Exception(
        'Solo el creador del proyecto puede aceptar esta solicitud.',
      );
    }

    // =====================================================
    // 4. VERIFICAR QUE EL PROYECTO_ROLE EXISTE
    // =====================================================

    final proyectoRol =
        await solicitudRepository
            .getProyectoRolById(
      idProyectoRol,
    );

    if (proyectoRol == null) {
      throw Exception(
        'No existe el proyecto_rol $idProyectoRol.',
      );
    }

    final idRol = int.tryParse(
      proyectoRol['id_rol'].toString(),
    );

    final cantidadMaxima = int.tryParse(
      proyectoRol['cantidad'].toString(),
    );

    if (
      idRol == null ||
      cantidadMaxima == null
    ) {
      throw Exception(
        'El proyecto_rol tiene datos inválidos.',
      );
    }

    // =====================================================
    // 5. VERIFICAR CUPOS DEL ROL
    // =====================================================

    final integrantes =
        await integranteRepository
            .getIntegrantesByProject(
      idProyecto,
    );

    final integrantesConEseRol =
        integrantes.where(
      (integrante) {
        final integranteRol =
            int.tryParse(
          integrante['id_rol'].toString(),
        );

        return integranteRol == idRol;
      },
    ).length;

    if (
      integrantesConEseRol >= cantidadMaxima
    ) {
      throw Exception(
        'El cupo para este rol ya está completo.',
      );
    }

    // =====================================================
    // 6. VERIFICAR QUE EL POSTULANTE NO SEA YA INTEGRANTE
    // =====================================================

    final integranteExistente =
        await integranteRepository
            .getIntegranteByUserAndProject(
      idUsuario: idUsuario,
      idProyecto: idProyecto,
    );

    if (integranteExistente != null) {
      throw Exception(
        'El usuario ya es integrante de este proyecto.',
      );
    }

    // =====================================================
    // 7. CREAR INTEGRANTE
    // =====================================================

    final integrante = Integrante(
      idUsuario: idUsuario,
      idProyecto: idProyecto,
      idRol: idRol,
    );

    final resultadoIntegrante =
        await integranteRepository.createIntegrante(
      integrante,
    );

    // =====================================================
    // 8. ACTUALIZAR SOLICITUD A ACEPTADO
    // =====================================================

    final resultadoSolicitud =
        await solicitudRepository.responderSolicitud(
      idSolicitud: idSolicitud,
      nuevoEstado: 'aceptado',
    );

    // =====================================================
    // 9. DEVOLVER AMBOS RESULTADOS
    // =====================================================

    return {
      'solicitud': resultadoSolicitud,
      'integrante': resultadoIntegrante,
    };
  }
}