import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';

Future<void> main() async {
  print('========================================');
  print('PRUEBA DE SESION AUTH + USUARIO');
  print('========================================');

  try {
    final sesionController = SesionController();

    // -----------------------------------------
    // 1. LOGIN
    // -----------------------------------------

    print('\n--- 1. LOGIN ---');

    final loginExitoso = await sesionController.iniciarSesion(
      email: 'registro_prueba_02@correo.com',
      password: 'RegistroPrueba!123',
    );

    print('Login exitoso: $loginExitoso');

    // -----------------------------------------
    // 2. ESTADO AUTH
    // -----------------------------------------

    print('\n--- 2. ESTADO AUTH ---');

    print(
      'Esta autenticado: '
      '${sesionController.estaAutenticado}',
    );

    print(
      'userId: '
      '${sesionController.usuarioAutenticado.value?.userId}',
    );

    // -----------------------------------------
    // 3. ESTADO DEL PERFIL
    // -----------------------------------------

    print('\n--- 3. ESTADO DEL PERFIL ---');

    print(
      'Tiene perfil: '
      '${sesionController.tienePerfil}',
    );

    print(
      'Necesita completar perfil: '
      '${sesionController.necesitaCompletarPerfil}',
    );

    // -----------------------------------------
    // 4. MOSTRAR PERFIL
    // -----------------------------------------

    final perfil = sesionController.perfilUsuario.value;

    if (perfil == null) {
      print('No existe perfil de usuario.');
    } else {
      print('Perfil encontrado:');
      print('id_usuario: ${perfil.idUsuario}');
      print('nombre_usuario: ${perfil.nombreUsuario}');
      print(
        'correo_institucional: '
        '${perfil.correoInstitucional}',
      );
      print('carrera: ${perfil.carrera}');
      print('semestre: ${perfil.semestre}');
      print('id_autenticador: ${perfil.idAutenticador}');
    }

    // -----------------------------------------
    // 5. LOGOUT
    // -----------------------------------------

    print('\n--- 4. LOGOUT ---');

    await sesionController.cerrarSesion();

    print(
      'Esta autenticado despues del logout: '
      '${sesionController.estaAutenticado}',
    );

    print(
      'Tiene perfil despues del logout: '
      '${sesionController.tienePerfil}',
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