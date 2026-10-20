import 'package:uncampusconnet/core/database/roble_client.dart';

Future<void> probarRoble() async {
  try {
    final roble = RobleClient.instance;

    print('==========================================');
    print('LOGIN');
    print('==========================================');

    final usuario = await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('LOGIN EXITOSO');
    print(usuario);

    print('------------------------------------------');

    final usuarioActual = await roble.currentUser();

    print('USUARIO ACTUAL');
    print(usuarioActual);

    print('------------------------------------------');

    final userId = usuarioActual['userId'];

    print('ID DE AUTENTICACIÓN DE ROBLE:');
    print(userId);

    print('------------------------------------------');
    print('CREANDO PERFIL EN LA TABLA usuario');

    final perfil = await roble.create('usuario', {
      'id_usuario': 1,
      'id_autenticador': userId,
      'nombre_usuario': 'Prueba Roble',
      'correo_institucional': 'prueba@correo.com',
      'carrera': 'Ingeniería de Sistemas',
      'semestre': 6,
    });

    print('PERFIL CREADO CORRECTAMENTE');
    print(perfil);

    print('==========================================');
  } catch (e) {
    print('==========================================');
    print('ERROR AL PROBAR ROBLE');
    print('==========================================');
    print(e);
    print('==========================================');
  }
}

Future<void> main() async {
  await probarRoble();
}