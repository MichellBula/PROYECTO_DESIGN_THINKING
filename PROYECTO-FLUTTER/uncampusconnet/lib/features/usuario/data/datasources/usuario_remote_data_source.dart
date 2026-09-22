import '../../domain/entities/usuario.dart';

abstract class UsuarioRemoteDataSource {
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