import 'package:uncampusconnet/features/auth/controllers/auth_controller.dart';
import 'package:uncampusconnet/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:uncampusconnet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:uncampusconnet/features/usuario/controllers/usuario_controller.dart';

Future<void> main() async {
  print('========================================');
  print('PRUEBA DE FLUJO AUTH + PERFIL');
  print('========================================');

  try {
    // -----------------------------------------
    // AUTH
    // -----------------------------------------

    final authDataSource = AuthRemoteDataSourceImpl();

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authDataSource,
    );

    final authController = AuthController(
      repository: authRepository,
    );

    // -----------------------------------------
    // 1. LOGIN
    // -----------------------------------------

    print('\n--- 1. LOGIN ---');

    final loginExitoso = await authController.login(
      email: 'registro_prueba_02@correo.com',
      password: 'RegistroPrueba!123',
    );

    print('Login exitoso: $loginExitoso');

    final usuarioAuth = authController.usuarioAutenticado.value;

    if (usuarioAuth == null) {
      print('ERROR: No se obtuvo el usuario autenticado.');
      return;
    }

    print('Cuenta autenticada:');
    print('userId: ${usuarioAuth.userId}');
    print('email: ${usuarioAuth.email}');
    print('name: ${usuarioAuth.name}');

    // -----------------------------------------
    // USUARIO
    // -----------------------------------------

    final usuarioController = UsuarioController();

    // -----------------------------------------
    // 2. BUSCAR PERFIL
    // -----------------------------------------

    print('\n--- 2. BUSCAR PERFIL ---');

    final perfilExistente =
        await usuarioController.obtenerMiPerfil(
      usuarioAuth.userId,
    );

    if (perfilExistente == null) {
      print('No existe perfil en la tabla usuario.');
      print('Esto es correcto para una cuenta nueva.');

      // ---------------------------------------
      // 3. CREAR PERFIL
      // ---------------------------------------

      print('\n--- 3. CREAR PERFIL ---');

      final perfilCreado =
          await usuarioController.crearPerfil(
        nombreUsuario: 'Usuario Registro',
        correoInstitucional: 'registro@uninorte.edu.co',
        carrera: 'Ingeniería de Sistemas',
        semestre: 6,
        idAutenticador: usuarioAuth.userId,
      );

      print('Perfil creado correctamente:');
      print('id_usuario: ${perfilCreado.idUsuario}');
      print('nombre_usuario: ${perfilCreado.nombreUsuario}');
      print(
        'correo_institucional: '
        '${perfilCreado.correoInstitucional}',
      );
      print('carrera: ${perfilCreado.carrera}');
      print('semestre: ${perfilCreado.semestre}');
      print('id_autenticador: ${perfilCreado.idAutenticador}');
    } else {
      print('El perfil ya existe.');

      print('id_usuario: ${perfilExistente.idUsuario}');
      print(
        'nombre_usuario: '
        '${perfilExistente.nombreUsuario}',
      );
      print(
        'correo_institucional: '
        '${perfilExistente.correoInstitucional}',
      );
      print('carrera: ${perfilExistente.carrera}');
      print('semestre: ${perfilExistente.semestre}');
      print(
        'id_autenticador: '
        '${perfilExistente.idAutenticador}',
      );
    }

    // -----------------------------------------
    // 4. VERIFICAR PERFIL
    // -----------------------------------------

    print('\n--- 4. VERIFICAR PERFIL ---');

    final perfilVerificado =
        await usuarioController.obtenerMiPerfil(
      usuarioAuth.userId,
    );

    if (perfilVerificado == null) {
      print('ERROR: El perfil no fue encontrado.');
    } else {
      print('Perfil encontrado correctamente.');

      print(
        'id_autenticador coincide: '
        '${perfilVerificado.idAutenticador == usuarioAuth.userId}',
      );
    }

    // -----------------------------------------
    // 5. LOGOUT
    // -----------------------------------------

    print('\n--- 5. LOGOUT ---');

    await authController.logout();

    print(
      'Esta autenticado: '
      '${authController.estaAutenticado}',
    );

    print('\n========================================');
    print('PRUEBA FINALIZADA');
    print('========================================');
  } catch (e, stackTrace) {
    print('\n========================================');
    print('ERROR EN LA PRUEBA');
    print('========================================');

    print(e);

    print('\nStackTrace:');
    print(stackTrace);
  }
}