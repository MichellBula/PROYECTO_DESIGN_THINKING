
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/widgets/etapa_form_dialog.dart';

void main() {
  Future<void> abrirFormulario(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showEtapaFormDialog(context);
                },
                child: const Text('Abrir formulario'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir formulario'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Muestra los campos del formulario de etapa',
    (tester) async {
      await abrirFormulario(tester);

      expect(find.text('Crear nueva etapa'), findsOneWidget);
      expect(find.text('Etiqueta'), findsOneWidget);
      expect(find.text('Descripción'), findsOneWidget);
      expect(find.text('Progreso'), findsOneWidget);
      expect(find.text('Guardar'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    },
  );

  testWidgets(
    'No permite guardar una etapa sin etiqueta',
    (tester) async {
      await abrirFormulario(tester);

      await tester.tap(find.text('Guardar'));
      await tester.pump();

      expect(
        find.text('Escribe una etiqueta para la etapa.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Valida que el progreso esté entre 0 y 100',
    (tester) async {
      await abrirFormulario(tester);

      await tester.enterText(
        find.byType(TextField).at(0),
        'Diseño',
      );

      await tester.enterText(
        find.byType(TextField).at(1),
        'Diseñar la interfaz de la aplicación',
      );

      await tester.enterText(
        find.byType(TextField).at(2),
        '150',
      );

      await tester.tap(find.text('Guardar'));
      await tester.pump();

      expect(
        find.text('El progreso debe estar entre 0 y 100.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Permite crear una etapa con datos válidos',
    (tester) async {
      EtapaData? etapaGuardada;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    etapaGuardada =
                        await showEtapaFormDialog(context);
                  },
                  child: const Text('Abrir formulario'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir formulario'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).at(0),
        'Diseño de interfaz',
      );

      await tester.enterText(
        find.byType(TextField).at(1),
        'Creación de las pantallas principales',
      );

      await tester.enterText(
        find.byType(TextField).at(2),
        '50',
      );

      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(etapaGuardada, isNotNull);
      expect(etapaGuardada!.etiqueta, 'Diseño de interfaz');
      expect(etapaGuardada!.progreso, 0.5);
    },
  );

  testWidgets(
    'Permite cancelar sin crear una etapa',
    (tester) async {
      EtapaData? resultado;
      bool formularioCerrado = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    resultado = await showEtapaFormDialog(context);
                    formularioCerrado = true;
                  },
                  child: const Text('Abrir formulario'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir formulario'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(formularioCerrado, isTrue);
      expect(resultado, isNull);
      expect(find.text('Crear nueva etapa'), findsNothing);
    },
  );
}
