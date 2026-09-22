import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> registrar({
    required String email,
    required String password,
    required String name,
  }) {
    return remoteDataSource.registrar(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<AuthUser?> obtenerUsuarioActual() {
    return remoteDataSource.obtenerUsuarioActual();
  }

  @override
  Future<void> restaurarSesion() {
    return remoteDataSource.restaurarSesion();
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  bool get estaAutenticado => remoteDataSource.estaAutenticado;
}