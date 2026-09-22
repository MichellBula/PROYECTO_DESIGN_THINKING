import 'package:uncampusconnet/features/auth/controllers/auth_controller.dart';
import 'package:uncampusconnet/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:uncampusconnet/features/auth/data/repositories/auth_repository_impl.dart';

Future<void> main() async {
  print('==============================');
  print('PRUEBA DE REGISTRO');
  print('==============================');

  try {
    final authDataSource = AuthRemoteDataSourceImpl();

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authDataSource,
    );

    final authController = AuthController(
      repository: authRepository,
    );

    print('\n--- REGISTRANDO CUENTA ---');

    final registrado = await authController.registrar(
      email: 'registro_prueba_01@correo.com',
      password: 'RegistroPrueba!123',
      name: 'Usuario Registro',
    );

    print('Registro exitoso: $registrado');

    print('\n--- ESTADO DE LA SESION ---');

    print(
      'Esta autenticado: ${authController.estaAutenticado}',
    );

    print('\n==============================');
    print('PRUEBA FINALIZADA');
    print('==============================');
  } catch (e, stackTrace) {
    print('\n==============================');
    print('ERROR EN EL REGISTRO');
    print('==============================');

    print(e);

    print('\nStackTrace:');
    print(stackTrace);
  }
}