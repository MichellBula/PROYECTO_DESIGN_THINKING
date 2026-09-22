import 'package:uncampusconnet/features/auth/controllers/auth_controller.dart';
import 'package:uncampusconnet/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:uncampusconnet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:uncampusconnet/features/usuario/data/datasources/usuario_remote_data_source_impl.dart';
import 'package:uncampusconnet/features/usuario/data/repositories/usuario_repository_impl.dart';

Future<void> main() async {
  print('==============================');
  print('INICIANDO PRUEBA DE AUTENTICACION');
  print('==============================');

  try {
    // -----------------------------------------
    // 1. Crear DataSource de autenticación
    // -----------------------------------------
    final authDataSource = AuthRemoteDataSourceImpl();

    // -----------------------------------------
    // 2. Crear Repository de autenticación
    // -----------------------------------------
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authDataSource,
    );

    // -----------------------------------------
    // 3. Crear Controller
    // -----------------------------------------
    final authController = AuthController(
      repository: authRepository,
    );

    // -----------------------------------------
    // 4. LOGIN
    // -----------------------------------------
    print('\n--- 1. LOGIN ---');

    final loginExitoso = await authController.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso: $loginExitoso');

    final usuarioAuth = authController.usuarioAutenticado.value;

    if (usuarioAuth == null) {
      print('ERROR: No se obtuvo el usuario autenticado.');
      return;
    }

    print('Usuario autenticado correctamente:');
    print('userId: ${usuarioAuth.userId}');
    print('email: ${usuarioAuth.email}');
    print('name: ${usuarioAuth.name}');

    // -----------------------------------------
    // 5. CONSULTAR USUARIO ACTUAL
    // -----------------------------------------
    print('\n--- 2. USUARIO ACTUAL ---');

    final usuarioActual = await authRepository.obtenerUsuarioActual();

    if (usuarioActual == null) {
      print('No hay usuario autenticado actualmente.');
    } else {
      print('Usuario actual obtenido correctamente:');
      print('userId: ${usuarioActual.userId}');
      print('email: ${usuarioActual.email}');
      print('name: ${usuarioActual.name}');
    }

    // -----------------------------------------
    // 6. CREAR DataSource de usuario
    // -----------------------------------------
    final usuarioDataSource = UsuarioRemoteDataSourceImpl();

    // -----------------------------------------
    // 7. Crear Repository de usuario
    // -----------------------------------------
    final usuarioRepository = UsuarioRepositoryImpl(
      remoteDataSource: usuarioDataSource,
    );

    // -----------------------------------------
    // 8. BUSCAR PERFIL EN TABLA usuario
    // -----------------------------------------
    print('\n--- 3. PERFIL EN TABLA USUARIO ---');

    final perfil = await usuarioRepository.obtenerUsuarioActual(
      usuarioAuth.userId,
    );

    if (perfil == null) {
      print('No se encontró un perfil en la tabla usuario.');
    } else {
      print('Perfil encontrado correctamente:');
      print('id_usuario: ${perfil.idUsuario}');
      print('nombre_usuario: ${perfil.nombreUsuario}');
      print('correo_institucional: ${perfil.correoInstitucional}');
      print('carrera: ${perfil.carrera}');
      print('semestre: ${perfil.semestre}');
      print('id_autenticador: ${perfil.idAutenticador}');

      // -----------------------------------------
      // 9. Verificar relación Auth ↔ Usuario
      // -----------------------------------------
      print('\n--- 4. VERIFICACION DE RELACION ---');

      if (perfil.idAutenticador == usuarioAuth.userId) {
        print('OK: id_autenticador coincide con userId de Roble Auth.');
      } else {
        print('ERROR: id_autenticador NO coincide con userId.');
      }
    }

    // -----------------------------------------
    // 10. ESTADO DE AUTENTICACION
    // -----------------------------------------
    print('\n--- 5. ESTADO DE AUTENTICACION ---');

    print(
      'AuthController.estaAutenticado: '
      '${authController.estaAutenticado}',
    );

    print(
      'AuthRepository.estaAutenticado: '
      '${authRepository.estaAutenticado}',
    );

    // -----------------------------------------
    // 11. LOGOUT
    // -----------------------------------------
    print('\n--- 6. LOGOUT ---');

    await authController.logout();

    print('Logout realizado correctamente.');
    print(
      'Esta autenticado despues del logout: '
      '${authController.estaAutenticado}',
    );

    print('\n==============================');
    print('PRUEBA FINALIZADA');
    print('==============================');
  } catch (e, stackTrace) {
    print('\n==============================');
    print('ERROR EN LA PRUEBA');
    print('==============================');
    print(e);
    print('\nStackTrace:');
    print(stackTrace);
  }
}