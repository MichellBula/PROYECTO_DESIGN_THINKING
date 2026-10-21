import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uncampusconnet/features/create_project/controllers/create_project_controller.dart';
import 'package:uncampusconnet/features/create_project/domain/entities/create_project_request.dart';
import 'package:uncampusconnet/features/create_project/domain/usecases/create_complete_project.dart';

class MockCreateCompleteProject extends Mock implements CreateCompleteProject {}

class FakeCreateProjectRequest extends Fake implements CreateProjectRequest {}

void main() {
  late MockCreateCompleteProject mockUseCase;
  late CreateProjectController controller;

  final tRequest = CreateProjectRequest(
    nombreProyecto: 'Test',
    descripcion: 'Desc',
    objetivo: 'Obj',
    categoria: 'Cat',
    tipoProyecto: 'Tipo',
    roles: ['Programador'],
    cantidadesPorRol: {'Programador': 1},
    habilidades: ['Java'],
    requisitos: 'Req',
    fechaInicio: DateTime.now(),
    fechaCierre: DateTime.now().add(const Duration(days: 10)),
    deseaDocente: false,
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateProjectRequest());
  });

  setUp(() {
    mockUseCase = MockCreateCompleteProject();
    controller = CreateProjectController(createCompleteProject: mockUseCase);
  });

  group('Pruebas Unitarias - CreateProjectController', () {
    test('Debe retornar true si el proyecto se publica exitosamente', () async {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => {'id': '123', 'status': 'ok'});

      final result = await controller.publicarProyecto(tRequest);

      expect(result, true);
      expect(controller.cargando.value, false);
      verify(() => mockUseCase(tRequest)).called(1);
    });

    test('Debe retornar false si ocurre un error (ej. falla Roble)', () async {
      when(() => mockUseCase(any())).thenThrow(Exception('Error de red'));

      final result = await controller.publicarProyecto(tRequest);

      expect(result, false);
      expect(controller.cargando.value, false);
    });
  });
}
