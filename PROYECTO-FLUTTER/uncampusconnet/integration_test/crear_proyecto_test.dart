import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uncampusconnet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de Integración - Crear Proyecto', () {
    testWidgets('El usuario puede crear un proyecto completo', (tester) async {
      // 1. Iniciar la aplicación
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 2. LOGIN (Para poder entrar a la app)
      final camposLogin = find.byType(TextField);
      await tester.enterText(camposLogin.at(0), 'prueba@correo.com');
      await tester.enterText(camposLogin.at(1), 'Prueba123!');
      await tester.tap(find.byKey(const Key('btn_login')));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // 3. Navegar a Crear Proyecto (Botón + en el menú)
      final btnCrear = find.byIcon(Icons.add_circle);
      await tester.tap(btnCrear);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 4. LLENAR PANTALLA 1 (Nuevo Proyecto)
      final inputsPaso1 = find.byType(TextField);
      
      // Campo 0: Nombre del proyecto
      await tester.enterText(inputsPaso1.at(0), 'Proyecto Automatizado');
      // Campo 1: Descripción
      await tester.enterText(inputsPaso1.at(1), 'Descripción creada por el robot.');
      // Campo 2: Líder
      await tester.enterText(inputsPaso1.at(2), 'Líder Robot');
      await tester.pumpAndSettle();

      // Seleccionar Categoría (Dropdown)
      // Buscamos el texto 'Selecciona una categoría' y hacemos clic
      await tester.tap(find.text('Selecciona una categoría'));
      await tester.pumpAndSettle();
      // Hacemos clic en la primera opción de la lista que aparezca
      await tester.tap(find.text('Tecnología').last); // <-- Asegúrate de que 'Tecnología' exista en tu lista
      await tester.pumpAndSettle();

      // Clic en Continuar
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 5. VERIFICAR QUE LLEGAMOS A DETALLES
      expect(find.text('Información general:'), findsOneWidget, 
          reason: 'No se avanzó a la pantalla de Detalles');

      // 6. LLENAR PANTALLA 2 (DetallesProyectoPage)
      final inputsPaso2 = find.byType(TextField);
      
      // Campo 0: Objetivo
      await tester.enterText(inputsPaso2.at(0), 'Objetivo del proyecto automatizado.');
      // Campo 1: Requisitos
      await tester.enterText(inputsPaso2.at(1), 'Requisitos del proyecto automatizado.');
      await tester.pumpAndSettle();

      // NOTA: El robot no tocará los dropdowns de Roles, Habilidades, 
      // Tipo de Proyecto ni las Fechas. Si tu formulario los exige,
      // aquí fallará y tendremos que agregar los clics.

      // 7. Clic en Continuar de la pantalla 2
      // Buscamos el botón que dice 'Continuar' (que es el último en la pantalla)
      await tester.tap(find.text('Continuar').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 8. VERIFICAR QUE LLEGAMOS A CONFIRMACIÓN
      // (Asumiendo que tu ConfirmarProyectoPage tiene un texto que dice 'Confirmar')
      expect(find.textContaining('Confirmar'), findsWidgets, 
          reason: 'No se avanzó a la pantalla de confirmación');
    });
  });
}