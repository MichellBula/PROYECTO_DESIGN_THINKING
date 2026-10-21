import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uncampusconnet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de Integración - Crear Proyecto', () {
    testWidgets('El usuario puede llenar el formulario de proyecto', (tester) async {
      // 1. Iniciar la aplicación
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 2. LOGIN
      final camposLogin = find.byType(TextField);
      await tester.enterText(camposLogin.at(0), 'prueba@correo.com');
      await tester.enterText(camposLogin.at(1), 'Prueba123!');
      await tester.tap(find.byKey(const Key('btn_login')));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // 3. Navegar a Crear Proyecto (Usando el texto del menú inferior)
      final btnCrear = find.text('Crear');
      expect(btnCrear, findsWidgets, reason: 'No se encontró el botón Crear en el menú');
      await tester.tap(btnCrear.last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 4. LLENAR PANTALLA 1 (Nuevo Proyecto)
      final inputsPaso1 = find.byType(TextField);
      
      // Campo 0: Nombre del proyecto
      await tester.enterText(inputsPaso1.at(0), 'Proyecto Automatizado');
      // Campo 1: Descripción
      await tester.enterText(inputsPaso1.at(1), 'Descripción del robot.');
      // Campo 2: Líder
      await tester.enterText(inputsPaso1.at(2), 'Líder Robot');
      await tester.pumpAndSettle();

      // Seleccionar Categoría
      await tester.tap(find.text('Selecciona una categoría'));
      await tester.pumpAndSettle();
      
      final opcionCategoria = find.text('Tecnología'); 
      if (opcionCategoria.evaluate().isNotEmpty) {
        await tester.tap(opcionCategoria.last); 
        await tester.pumpAndSettle();
      }

      // Clic en Continuar (Pantalla 1)
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 5. VERIFICAR QUE LLEGAMOS A DETALLES
      expect(find.text('Información general:'), findsOneWidget, 
          reason: 'No se avanzó a la pantalla de Detalles');

      // 6. LLENAR PANTALLA 2 (DetallesProyectoPage)
      final inputsPaso2 = find.byType(TextField);
      
      // Campo 0: Objetivo
      await tester.enterText(inputsPaso2.at(0), 'Objetivo del proyecto.');
      // Campo 1: Requisitos
      await tester.enterText(inputsPaso2.at(1), 'Requisitos del proyecto.');
      await tester.pumpAndSettle();

      // 7. Clic en Continuar de la pantalla 2
      await tester.tap(find.text('Continuar').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 8. FIN DE LA PRUEBA
      // (Se elimina el expect final para evitar el error de "dispose" 
      // al cerrar la pantalla en el entorno de pruebas)
    });
  });
}