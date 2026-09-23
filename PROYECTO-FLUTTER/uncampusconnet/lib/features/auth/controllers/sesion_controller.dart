import 'package:get/get.dart';

import '../../usuario/data/datasources/usuario_remote_data_source_impl.dart';
import '../../usuario/data/repositories/usuario_repository_impl.dart';
import '../../usuario/domain/entities/usuario.dart';
import '../data/datasources/auth_remote_data_source_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/auth_user.dart';


class SesionController extends GetxController {
  SesionController({
    AuthRepositoryImpl? authRepository,
    UsuarioRepositoryImpl? usuarioRepository,
  })  : authRepository = authRepository ??
            AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            ),
        usuarioRepository = usuarioRepository ??
            UsuarioRepositoryImpl(
              remoteDataSource: UsuarioRemoteDataSourceImpl(),
            );

  final AuthRepositoryImpl authRepository;
  final UsuarioRepositoryImpl usuarioRepository;

  /// Usuario autenticado (Roble Auth)
  final Rxn<AuthUser> usuarioAutenticado = Rxn<AuthUser>();

  /// Perfil del usuario (tabla usuario)
  final Rxn<Usuario> perfilUsuario = Rxn<Usuario>();

  /// Indicador de carga
  final RxBool cargando = false.obs;

  
  bool get estaAutenticado => usuarioAutenticado.value != null;

  bool get tienePerfil => perfilUsuario.value != null;

  bool get necesitaCompletarPerfil =>
      estaAutenticado && !tienePerfil;

  //Registrar cuenta
  Future<bool> registrarCuenta({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      cargando.value = true;

      // 1. Registrar en Roble Auth
      await authRepository.registrar(
        email: email,
        password: password,
        name: name,
      );

      // 2. Login automático (para tener usuarioAutenticado)
      final authUser = await authRepository.login(
        email: email,
        password: password,
      );

      usuarioAutenticado.value = authUser;

      return true;
    } catch (e) {
      usuarioAutenticado.value = null;
      rethrow;
    } finally {
      cargando.value = false;
    }
  }

  //Iniciar sesion
  Future<bool> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      cargando.value = true;

      // 1. Login en Roble Auth
      final authUser = await authRepository.login(
        email: email,
        password: password,
      );

      usuarioAutenticado.value = authUser;

      // 2. Buscar perfil en la tabla usuario
      final perfil = await usuarioRepository.obtenerUsuarioActual(
        authUser.userId,
      );

      perfilUsuario.value = perfil;

      return true;
    } catch (e) {
      usuarioAutenticado.value = null;
      perfilUsuario.value = null;
      rethrow;
    } finally {
      cargando.value = false;
    }
  }

  //Restaurar sesion
  Future<void> restaurarSesion() async {
    try {
      cargando.value = true;

      await authRepository.restaurarSesion();

      final authUser = await authRepository.obtenerUsuarioActual();

      usuarioAutenticado.value = authUser;

      // Si hay usuario, buscar su perfil
      if (authUser != null) {
        final perfil = await usuarioRepository.obtenerUsuarioActual(
          authUser.userId,
        );

        perfilUsuario.value = perfil;
      }
    } catch (e) {
      usuarioAutenticado.value = null;
      perfilUsuario.value = null;
      rethrow;
    } finally {
      cargando.value = false;
    }
  }

  //Actualizar perfil
  Future<Usuario?> actualizarPerfil() async {
    final authUser = usuarioAutenticado.value;

    if (authUser == null) {
      perfilUsuario.value = null;
      return null;
    }

    try {
      cargando.value = true;

      final perfil = await usuarioRepository.obtenerUsuarioActual(
        authUser.userId,
      );

      perfilUsuario.value = perfil;

      return perfil;
    } finally {
      cargando.value = false;
    }
  }

  //Cerrar sesion
  Future<void> cerrarSesion() async {
    await authRepository.logout();

    usuarioAutenticado.value = null;
    perfilUsuario.value = null;
  }
}