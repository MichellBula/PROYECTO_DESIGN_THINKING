import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';

Future<void> main() async {
  print('========================================');
  print('PRUEBAS FINALES DE AUTH + USUARIO');
  print('========================================');

  final sesionController = SesionController();

  // =========================================================
  // PRUEBA 1: REGISTRAR UNA CUENTA QUE YA EXISTE
  // =========================================================

  print('\n========================================');
  print('PRUEBA 1: CUENTA YA EXISTENTE');
  print('========================================');

  try {
    await sesionController.registrarCuenta(
      email: 'registro_prueba_02@correo.com',
      password: 'RegistroPrueba!123',
      name: 'Usuario Duplicado',
    );

    print('ERROR: Roble permitió registrar una cuenta existente.');
  } catch (e) {
    print('Registro rechazado correctamente.');
    print('Respuesta de Roble:');
    print(e);
  }

  // =========================================================
  // PRUEBA 2: CUENTA NUEVA SIN PERFIL
  // =========================================================

  print('\n========================================');
  print('PRUEBA 2: CUENTA NUEVA SIN PERFIL');
  print('========================================');

  try {
    final identificador =
        DateTime.now().millisecondsSinceEpoch;

    final emailNuevo =
        'registro_sin_perfil_$identificador@correo.com';

    const passwordNuevo = 'RegistroSinPerfil!123';
    const nombreNuevo = 'Usuario Sin Perfil';

    print('\n--- 1. CREAR CUENTA ---');

    final registroExitoso =
        await sesionController.registrarCuenta(
      email: emailNuevo,
      password: passwordNuevo,
      name: nombreNuevo,
    );

    print('Registro exitoso: $registroExitoso');
    print('Correo creado: $emailNuevo');

    print('\n--- 2. INICIAR SESION ---');

    final loginExitoso =
        await sesionController.iniciarSesion(
      email: emailNuevo,
      password: passwordNuevo,
    );

    print('Login exitoso: $loginExitoso');

    final usuarioAuth =
        sesionController.usuarioAutenticado.value;

    if (usuarioAuth == null) {
      print('ERROR: No se obtuvo el usuario autenticado.');
    } else {
      print('Cuenta autenticada correctamente.');
      print('userId: ${usuarioAuth.userId}');
      print('email: ${usuarioAuth.email}');
      print('name: ${usuarioAuth.name}');
    }

    print('\n--- 3. COMPROBAR PERFIL ---');

    print(
      'Esta autenticado: '
      '${sesionController.estaAutenticado}',
    );

    print(
      'Tiene perfil: '
      '${sesionController.tienePerfil}',
    );

    print(
      'Necesita completar perfil: '
      '${sesionController.necesitaCompletarPerfil}',
    );

    if (sesionController.necesitaCompletarPerfil) {
      print('OK: La cuenta existe pero todavía no tiene perfil.');
    } else {
      print(
        'ERROR: La cuenta nueva no fue detectada '
        'como perfil pendiente.',
      );
    }

    print('\n--- 4. CERRAR SESION ---');

    await sesionController.cerrarSesion();

    print(
      'Esta autenticado despues del logout: '
      '${sesionController.estaAutenticado}',
    );

    print(
      'Tiene perfil despues del logout: '
      '${sesionController.tienePerfil}',
    );
  } catch (e, stackTrace) {
    print('\nERROR EN LA PRUEBA 2:');
    print(e);
    print('\nStackTrace:');
    print(stackTrace);
  }

  print('\n========================================');
  print('PRUEBAS FINALIZADAS');
  print('========================================');
}