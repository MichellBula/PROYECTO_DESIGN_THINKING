import 'package:uncampusconnet/core/database/roble_client.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE ESQUEMA - PROYECTO');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    // ======================================================
    // LOGIN
    // ======================================================

    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    // ======================================================
    // LEER TABLA PROYECTO
    // ======================================================

    print('\n--- LEYENDO TABLA PROYECTO ---');

    final proyectos = await roble.read('proyecto');

    print('Cantidad de registros: ${proyectos.length}');

    // ======================================================
    // MOSTRAR COLUMNAS RECONOCIDAS POR ROBLE
    // ======================================================

    if (proyectos.isEmpty) {
      print('\nLa tabla proyecto está vacía.');
      print(
        'No hay registros de los cuales obtener las columnas.',
      );
    } else {
      print('\n--- COLUMNAS RECONOCIDAS POR ROBLE ---');

      final primerRegistro =
          Map<String, dynamic>.from(proyectos.first);

      for (final clave in primerRegistro.keys) {
        print(
          '$clave → '
          '${primerRegistro[clave].runtimeType} → '
          '${primerRegistro[clave]}',
        );
      }

      print('\n--- MAPA COMPLETO ---');
      print(primerRegistro);
    }

    // ======================================================
    // LOGOUT
    // ======================================================

    print('\n--- LOGOUT ---');

    await roble.logout();

    print('Logout exitoso.');

    print('\n========================================');
    print('TEST FINALIZADO');
    print('========================================');
  } catch (e, stackTrace) {
    print('\n========================================');
    print('ERROR EN EL TEST');
    print('========================================');
    print(e);

    print('\nStackTrace:');
    print(stackTrace);
  }
}