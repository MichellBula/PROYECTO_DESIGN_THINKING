import '../entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario> crearUsuario({
    required String nombreUsuario,
    required String correoInstitucional,
    required String carrera,
    required int semestre,
    required String idAutenticador,
  });

  Future<Usuario?> obtenerUsuarioActual(String idAutenticador);

  Future<Usuario?> obtenerUsuarioPorId(int idUsuario);
}