
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/pages/agregar_avance_page.dart';

void main() {
  // Abre el formulario de avances.
  Future<void> abrirFormulario(
    WidgetTester tester, {
    AvanceData? avance,
    ValueChanged<AvanceData?>? onResultado,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  final resultado =
                      await Navigator.of(context).push<AvanceData>(
                    MaterialPageRoute(
                      builder: (_) => AgregarAvancePage(
                        numeroEtapa: 1,
                        nombreEtapa: 'Diseño',
                        avance: avance,
                      ),
                    ),
                  );

                  onResultado?.call(resultado);
                },
                child: const Text('Abrir avance'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir avance'));
    await tester.pumpAndSettle();
  }

  // Desplaza el formulario principal hasta el final.
  Future<void> buscarBoton(
    WidgetTester tester,
    String texto,
  ) async {
    // Cierra el teclado si está abierto.
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    // Busca el ListView principal del formulario.
    final scrollable = tester.state<ScrollableState>(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ).first,
    );

    // Desplaza hasta el final.
    scrollable.position.jumpTo(
      scrollable.position.maxScrollExtent,
    );

    await tester.pumpAndSettle();

    expect(find.text(texto), findsOneWidget);
  }

  // PRUEBA 1: Mostrar los campos.
  testWidgets(
    'Muestra los campos para crear un avance',
    (tester) async {
      await abrirFormulario(tester);

      expect(find.text('Crear nuevo avance'), findsOneWidget);
      expect(find.text('Etapa #1: Diseño'), findsOneWidget);
      expect(find.text('Título del avance'), findsOneWidget);
      expect(find.text('Responsable'), findsOneWidget);
      expect(find.text('Fecha del avance'), findsOneWidget);
      expect(find.text('Descripción del avance'), findsOneWidget);

      await buscarBoton(tester, 'Guardar avance');

      expect(find.text('Guardar avance'), findsOneWidget);
    },
  );

  // PRUEBA 2: Validar campos obligatorios.
  testWidgets(
    'Valida que el título y la descripción sean obligatorios',
    (tester) async {
      await abrirFormulario(tester);

      await buscarBoton(tester, 'Guardar avance');

      await tester.tap(find.text('Guardar avance'));
      await tester.pump();

      expect(
        find.text(
          'Completa el título y la descripción del avance.',
        ),
        findsOneWidget,
      );
    },
  );

  // PRUEBA 3: Guardar un avance válido.
  testWidgets(
    'Permite guardar un avance con datos válidos',
    (tester) async {
      AvanceData? avanceGuardado;

      await abrirFormulario(
        tester,
        onResultado: (resultado) {
          avanceGuardado = resultado;
        },
      );

      await tester.enterText(
        find.byType(TextField).at(0),
        'Investigación completada',
      );

      await tester.enterText(
        find.byType(TextField).at(1),
        'Se completó la investigación inicial.',
      );

      await buscarBoton(tester, 'Guardar avance');

      await tester.tap(find.text('Guardar avance'));
      await tester.pumpAndSettle();

      expect(avanceGuardado, isNotNull);

      expect(
        avanceGuardado!.etiqueta,
        'Investigación completada',
      );

      expect(
        avanceGuardado!.descripcion,
        'Se completó la investigación inicial.',
      );

      expect(
        avanceGuardado!.autor,
        'Usuario de la sesión actual',
      );
    },
  );

  // PRUEBA 4: Cancelar sin guardar.
  testWidgets(
    'Permite cancelar sin guardar el avance',
    (tester) async {
      AvanceData? resultado;
      bool paginaCerrada = false;

      await abrirFormulario(
        tester,
        onResultado: (avance) {
          resultado = avance;
          paginaCerrada = true;
        },
      );

      await buscarBoton(tester, 'Cancelar');

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(paginaCerrada, isTrue);
      expect(resultado, isNull);
      expect(find.text('Crear nuevo avance'), findsNothing);
    },
  );

  // PRUEBA 5: Editar un avance existente.
  testWidgets(
    'Permite editar un avance existente',
    (tester) async {
      final avanceOriginal = AvanceData(
        autor: 'Michell',
        etiqueta: 'Investigación inicial',
        descripcion: 'Primera investigación',
        fecha: DateTime(2026, 10, 20),
        archivos: const [],
      );

      AvanceData? avanceEditado;

      await abrirFormulario(
        tester,
        avance: avanceOriginal,
        onResultado: (resultado) {
          avanceEditado = resultado;
        },
      );

      expect(find.text('Editar avance'), findsOneWidget);

      // Verifica los datos iniciales.
      expect(
        tester
            .widget<TextField>(
              find.byType(TextField).at(0),
            )
            .controller!
            .text,
        'Investigación inicial',
      );

      // Cambia el título.
      await tester.enterText(
        find.byType(TextField).at(0),
        'Investigación actualizada',
      );

      // Cambia la descripción.
      await tester.enterText(
        find.byType(TextField).at(1),
        'Investigación finalizada',
      );

      // Actualiza el avance.
      await buscarBoton(tester, 'Actualizar');

      await tester.tap(find.text('Actualizar'));
      await tester.pumpAndSettle();

      expect(avanceEditado, isNotNull);

      expect(
        avanceEditado!.etiqueta,
        'Investigación actualizada',
      );

      expect(
        avanceEditado!.descripcion,
        'Investigación finalizada',
      );

      expect(
        avanceEditado!.autor,
        avanceOriginal.autor,
      );

      expect(
        avanceEditado!.fecha,
        avanceOriginal.fecha,
      );
    },
  );
}
