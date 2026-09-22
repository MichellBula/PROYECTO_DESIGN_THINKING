import 'package:uncampusconnet/core/database/roble_client.dart';

import '../../domain/entities/auth_user.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthUser _mapearUsuario(Map<String, dynamic> user) {
    return AuthUser(
      userId: user['userId'] as String,
      email: user['email'] as String,
      name: user['name'] as String,
    );
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final user = await RobleClient.instance.login(
      email: email,
      password: password,
    );

    return _mapearUsuario(
      Map<String, dynamic>.from(user),
    );
  }

  @override
  Future<void> registrar({
    required String email,
    required String password,
    required String name,
  }) async {
    await RobleClient.instance.register(
      email: email,
      password: password,
      name: name,
      autoLogin: false,
    );
  }

  @override
  Future<AuthUser?> obtenerUsuarioActual() async {
    final user = await RobleClient.instance.currentUser();

    return _mapearUsuario(
      Map<String, dynamic>.from(user),
    );
  }

  @override
  Future<void> restaurarSesion() async {
    await RobleClient.instance.restoreSession();
  }

  @override
  Future<void> logout() async {
    await RobleClient.instance.logout();
  }

  @override
  bool get estaAutenticado => RobleClient.instance.isLoggedIn;
}