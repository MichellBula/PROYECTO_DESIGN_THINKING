import '../../domain/entities/auth_user.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<void> registrar({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthUser?> obtenerUsuarioActual();

  Future<void> restaurarSesion();

  Future<void> logout();

  bool get estaAutenticado;
}