import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuario_remote_data_source.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDataSource remoteDataSource;

  UsuarioRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Usuario> crearUsuario({
    required String nombreUsuario,
    required String correoInstitucional,
    required String carrera,
    required int semestre,
    required String idAutenticador,
  }) {
    return remoteDataSource.crearUsuario(
      nombreUsuario: nombreUsuario,
      correoInstitucional: correoInstitucional,
      carrera: carrera,
      semestre: semestre,
      idAutenticador: idAutenticador,
    );
  }

  @override
  Future<Usuario?> obtenerUsuarioActual(String idAutenticador) {
    return remoteDataSource.obtenerUsuarioActual(
      idAutenticador,
    );
  }

  @override
  Future<Usuario?> obtenerUsuarioPorId(int idUsuario) {
    return remoteDataSource.obtenerUsuarioPorId(
      idUsuario,
    );
  }
}