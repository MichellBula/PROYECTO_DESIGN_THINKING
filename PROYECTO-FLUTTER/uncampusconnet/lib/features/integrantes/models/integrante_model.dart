import '../domain/entities/integrante.dart';

class IntegranteModel extends Integrante {
  const IntegranteModel({
    required super.idUsuario,
    required super.idProyecto,
    required super.idRol,
  });

  factory IntegranteModel.fromEntity(
    Integrante integrante,
  ) {
    return IntegranteModel(
      idUsuario: integrante.idUsuario,
      idProyecto: integrante.idProyecto,
      idRol: integrante.idRol,
    );
  }

  Map<String, dynamic> toMap({
    required int idUsuarioIntegrante,
  }) {
    return {
      'id_usuario_integrante': idUsuarioIntegrante,
      'id_usuario': idUsuario,
      'id_proyecto': idProyecto,
      'id_rol': idRol,
    };
  }
}