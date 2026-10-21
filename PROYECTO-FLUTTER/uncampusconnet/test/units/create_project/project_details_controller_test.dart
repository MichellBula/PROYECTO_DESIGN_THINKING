import 'package:flutter_test/flutter_test.dart';
import 'package:uncampusconnet/features/create_project/controllers/project_details_controller.dart';

void main() {
  late ProjectDetailsController controller;

  setUp(() {
    controller = ProjectDetailsController();
  });

  group('Pruebas Unitarias - ProjectDetailsController Validate', () {
    test('Debe retornar error si el objetivo está vacío', () {
      final error = controller.validate();
      expect(error, 'Debes completar el objetivo general.');
    });

    test('Debe retornar error si no hay roles seleccionados', () {
      controller.objetivoController.text = 'Mi objetivo';
      final error = controller.validate();
      expect(error, 'Debes seleccionar al menos un rol.');
    });

    test('Debe retornar error si no hay habilidades seleccionadas', () {
      controller.objetivoController.text = 'Mi objetivo';
      controller.actualizarRoles({'Programador': 1});
      final error = controller.validate();
      expect(error, 'Debes seleccionar al menos una habilidad.');
    });

    test('Debe retornar error si faltan los requisitos', () {
      controller.objetivoController.text = 'Mi objetivo';
      controller.actualizarRoles({'Programador': 1});
      controller.actualizarHabilidades(['Java']);

      // (Aquí probamos que falle por requisitos)
      final error = controller.validate();
      expect(error, 'Debes completar los requisitos.');
    });

    test('Debe retornar error si falta el tipo de proyecto', () {
      controller.objetivoController.text = 'Mi objetivo';
      controller.actualizarRoles({'Programador': 1});
      controller.actualizarHabilidades(['Java']);
      controller.requisitosController.text =
          'Requisitos de prueba'; // Llenamos requisitos

      final error = controller.validate();
      expect(error, 'Debes seleccionar el tipo de proyecto.');
    });

    test('Debe retornar error si falta la fecha de inicio', () {
      controller.objetivoController.text = 'Mi objetivo';
      controller.actualizarRoles({'Programador': 1});
      controller.actualizarHabilidades(['Java']);
      controller.requisitosController.text = 'Requisitos de prueba';
      controller.cambiarTipoProyecto('Investigación'); // Llenamos tipo

      final error = controller.validate();
      expect(error, 'Debes seleccionar la fecha de inicio.');
    });

    test('Debe retornar null (éxito) cuando TODOS los campos son válidos', () {
      controller.objetivoController.text = 'Mi objetivo';
      controller.actualizarRoles({'Programador': 1});
      controller.actualizarHabilidades(['Java']);
      controller.requisitosController.text = 'Requisitos de prueba';
      controller.cambiarTipoProyecto('Investigación');

      final hoy = DateTime.now();
      final enDiezDias = hoy.add(const Duration(days: 10));

      controller.setFechaInicio(hoy);
      controller.setFechaCierre(enDiezDias);

      final error = controller.validate();
      expect(error, isNull);
    });
  });
}
