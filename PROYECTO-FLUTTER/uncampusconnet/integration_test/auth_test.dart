import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uncampusconnet/main.dart' as app;

void main() {
  // Requerido por Flutter para pruebas de integración
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de Integración - Login y Crear Proyecto', () {
    testWidgets('El usuario puede iniciar sesión y entrar a crear proyecto',
        (tester) async {
      // 1. Iniciar la aplicación real
      app.main();
      // Esperar a que cargue la pantalla de login
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 2. Buscar los campos de texto (AppTextField usa TextField por dentro)
      final camposTexto = find.byType(TextField);
      expect(camposTexto, findsNWidgets(2),
          reason: 'No se encontraron los 2 campos de login');

      // 3. Escribir credenciales de prueba
      await tester.enterText(camposTexto.at(0), 'prueba@correo.com');
      await tester.enterText(camposTexto.at(1), 'Prueba123!');
      await tester.pumpAndSettle();

      // 4. Dar clic en el botón de Iniciar Sesión (usando la llave que pusimos)
      final btnLogin = find.byKey(const Key('btn_login'));
      expect(btnLogin, findsOneWidget,
          reason: 'No se encontró el botón de login');

      await tester.tap(btnLogin);

      // 5. Esperar a que cargue el Home (conecta con Roble, por eso damos 10s)
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verificamos que ya no estamos en el login (el botón desapareció)
      expect(btnLogin, findsNothing, reason: 'El login falló o no navegó');

      // 6. Buscar el botón para ir a Crear Proyecto en la barra inferior
      // Nota: Asegúrate de que tu BottomNavBar tenga este icono o usa find.text('Crear')
      final btnCrear = find.byIcon(Icons.add_circle);
      if (btnCrear.evaluate().isNotEmpty) {
        await tester.tap(btnCrear.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // 7. Verificar que estamos en la pantalla de Crear Proyecto
      // (Asumiendo que la pantalla tiene algún texto con la palabra "Proyecto")
      expect(find.textContaining('Proyecto'), findsWidgets,
          reason: 'No se llegó a crear proyecto');
    });
  });
}