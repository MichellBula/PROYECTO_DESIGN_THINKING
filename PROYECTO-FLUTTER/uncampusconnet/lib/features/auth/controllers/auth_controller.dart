import 'package:get/get.dart';

import '../domain/entities/auth_user.dart';
import '../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repository;

  AuthController({
    required this.repository,
  });

  final Rxn<AuthUser> usuarioAutenticado = Rxn<AuthUser>();

  final RxBool cargando = false.obs;

  bool get estaAutenticado => usuarioAutenticado.value != null;

  Future<bool> registrar({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      cargando.value = true;

      await repository.registrar(
        email: email,
        password: password,
        name: name,
      );

      return true;
    } catch (e) {
      usuarioAutenticado.value = null;
      rethrow;
    } finally {
      cargando.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      cargando.value = true;

      final usuario = await repository.login(
        email: email,
        password: password,
      );

      usuarioAutenticado.value = usuario;

      return true;
    } catch (e) {
      usuarioAutenticado.value = null;
      rethrow;
    } finally {
      cargando.value = false;
    }
  }

  Future<void> restaurarSesion() async {
    try {
      cargando.value = true;

      await repository.restaurarSesion();

      final usuario = await repository.obtenerUsuarioActual();

      usuarioAutenticado.value = usuario;
    } catch (e) {
      usuarioAutenticado.value = null;
      rethrow;
    } finally {
      cargando.value = false;
    }
  }

  Future<void> logout() async {
    await repository.logout();

    usuarioAutenticado.value = null;
  }
}