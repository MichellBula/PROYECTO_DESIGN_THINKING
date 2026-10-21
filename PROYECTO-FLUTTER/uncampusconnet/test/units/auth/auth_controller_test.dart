import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uncampusconnet/features/auth/controllers/auth_controller.dart';
import 'package:uncampusconnet/features/auth/domain/entities/auth_user.dart';
import 'package:uncampusconnet/features/auth/domain/repositories/auth_repository.dart';

// 1. Creamos un Mock del Repositorio
class MockAuthRepository extends Mock implements AuthRepository {}

// 2. Creamos un usuario de prueba falso
final tAuthUser = AuthUser(
  userId: '123',
  email: 'test@correo.com',
  name: 'Usuario Test',
);

void main() {
  // Inicializamos la librería de mocking
  setUpAll(() {
    registerFallbackValue(tAuthUser);
  });

  late MockAuthRepository mockRepository;
  late AuthController authController;

  // Antes de cada prueba, creamos instancias limpias
  setUp(() {
    mockRepository = MockAuthRepository();
    authController = AuthController(repository: mockRepository);
  });

  // =====================================================
  // PRUEBAS DE LOGIN
  // =====================================================
  group('Pruebas Unitarias - AuthController login', () {
    test(
      'Debe retornar true y guardar el usuario si el login es exitoso',
      () async {
        // ARRANGE (Preparar)
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tAuthUser);

        // ACT (Actuar)
        final result = await authController.login(
          email: 'test@correo.com',
          password: 'Password123!',
        );

        // ASSERT (Verificar)
        expect(result, true);
        expect(authController.usuarioAutenticado.value, tAuthUser);
        expect(authController.estaAutenticado, true);
        expect(
          authController.cargando.value,
          false,
        ); // Debe haber terminado de cargar

        // Verificamos que el repositorio fue llamado con los datos correctos
        verify(
          () => mockRepository.login(
            email: 'test@correo.com',
            password: 'Password123!',
          ),
        ).called(1);
      },
    );

    test('Debe lanzar excepcion y limpiar usuario si el login falla', () async {
      // ARRANGE
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Credenciales incorrectas'));

      // ACT & ASSERT
      expect(
        () => authController.login(
          email: 'test@correo.com',
          password: 'WrongPassword',
        ),
        throwsException,
      );

      // Verificamos que el estado quedó limpio y cargando en false
      expect(authController.usuarioAutenticado.value, null);
      expect(authController.estaAutenticado, false);
      expect(authController.cargando.value, false);
    });
  });

  // =====================================================
  // PRUEBAS DE LOGOUT
  // =====================================================
  group('Pruebas Unitarias - AuthController logout', () {
    test('Debe limpiar el usuario autenticado al hacer logout', () async {
      // ARRANGE: Primero simulemos que ya hay un usuario logueado
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tAuthUser);

      await authController.login(email: 'test@correo.com', password: '123');
      expect(authController.usuarioAutenticado.value, isNotNull);

      // Simulamos la respuesta del repositorio al hacer logout
      when(() => mockRepository.logout()).thenAnswer((_) async => {});

      // ACT
      await authController.logout();

      // ASSERT
      expect(authController.usuarioAutenticado.value, null);
      expect(authController.estaAutenticado, false);
      verify(() => mockRepository.logout()).called(1);
    });
  });
}
