
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

  // PRUEBA 1: Mostrar los campos del formulario
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

  // PRUEBA 2: Validar etiqueta obligatoria
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

  // PRUEBA 3: Validar porcentaje de progreso
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

  // PRUEBA 4: Crear una etapa correctamente
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
      expect(
        etapaGuardada!.descripcion,
        'Creación de las pantallas principales',
      );
      expect(etapaGuardada!.progreso, 0.5);
    },
  );

  // PRUEBA 5: Cancelar sin guardar
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

  // PRUEBA 6: Editar una etapa existente
  testWidgets(
    'Permite editar una etapa existente',
    (tester) async {
      final etapaOriginal = EtapaData(
        etiqueta: 'Diseño inicial',
        descripcion: 'Primera versión del diseño',
        progreso: 0.25,
        fechaFin: DateTime(2026, 12, 30),
        avances: const [],
      );

      EtapaData? etapaEditada;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    etapaEditada = await showEtapaFormDialog(
                      context,
                      etapa: etapaOriginal,
                    );
                  },
                  child: const Text('Abrir edición'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir edición'));
      await tester.pumpAndSettle();

      // Verificar que se abre en modo edición
      expect(find.text('Editar etapa'), findsOneWidget);

      // Verificar que se cargan los datos originales
      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(0))
            .controller!
            .text,
        'Diseño inicial',
      );

      expect(
        tester
            .widget<TextField>(find.byType(TextField).at(2))
            .controller!
            .text,
        '25',
      );

      // Modificar los campos
      await tester.enterText(
        find.byType(TextField).at(0),
        'Diseño actualizado',
      );

      await tester.enterText(
        find.byType(TextField).at(1),
        'Diseño final de la aplicación',
      );

      await tester.enterText(
        find.byType(TextField).at(2),
        '80',
      );

      // Guardar los cambios
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      // Comprobar los resultados
      expect(etapaEditada, isNotNull);
      expect(etapaEditada!.etiqueta, 'Diseño actualizado');
      expect(
        etapaEditada!.descripcion,
        'Diseño final de la aplicación',
      );
      expect(etapaEditada!.progreso, 0.8);
      expect(
        etapaEditada!.fechaFin,
        etapaOriginal.fechaFin,
      );
    },
  );
}
