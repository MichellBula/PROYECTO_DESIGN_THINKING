import '../domain/entities/usuario_habilidad.dart';

class UsuarioHabilidadModel extends UsuarioHabilidad {
  const UsuarioHabilidadModel({
    required super.idUsuario,
    required super.idHabilidad,
  });

  factory UsuarioHabilidadModel.fromEntity(
    UsuarioHabilidad usuarioHabilidad,
  ) {
    return UsuarioHabilidadModel(
      idUsuario: usuarioHabilidad.idUsuario,
      idHabilidad: usuarioHabilidad.idHabilidad,
    );
  }

  Map<String, dynamic> toMap({
    required int idUsuarioHabilidades,
  }) {
    return {
      'id_usuario_habilidades': idUsuarioHabilidades,
      'id_habilidad': idHabilidad,
      'id_usuario': idUsuario,
    };
  }
}