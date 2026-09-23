import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/auth/pages/completar_perfil_page.dart';
import 'package:uncampusconnet/features/auth/pages/register_page.dart';
import 'package:uncampusconnet/ui/widgets/main_scaffold.dart';
import 'package:uncampusconnet/ui/widgets/text_field.dart';

// ======================================================
// PÁGINA DE LOGIN
// ======================================================

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Get.put(SesionController());

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Validación básica
    if (emailCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Campos vacíos',
        'Por favor completa todos los campos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final ok = await controller.iniciarSesion(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      if (!ok || !mounted) return;

      // Decide a dónde ir según si tiene perfil
      if (controller.necesitaCompletarPerfil) {
        Get.offAll(() => const CompletarPerfilPage());
      } else {
        Get.offAll(() => const MainScaffold());
      }
    } catch (e) {
      Get.snackbar(
        'Credenciales incorrectas',
        'Verifica tu email y contraseña',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO
                  Image.asset('assets/images/logo.png', height: 100),
                  const SizedBox(height: 20),

                  // TÍTULO
                  Text(
                    'Bienvenido',
                    style: AppTextStyles.greeting.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Inicia sesión para continuar',
                    style: AppTextStyles.subtitle.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // EMAIL
                  AppTextField(
                    label: 'Email',
                    hint: 'tu@correo.com',
                    controller: emailCtrl,
                    maxLength: 100,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // CONTRASEÑA
                  AppTextField(
                    label: 'Contraseña',
                    hint: '••••••••',
                    controller: passCtrl,
                    maxLength: 50,
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),

                  // BOTÓN LOGIN
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.cargando.value ? null : _login,
                        child: controller.cargando.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Iniciar sesión',
                                style: AppTextStyles.buttonText,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // REGISTRARSE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta?',
                        style: AppTextStyles.bodyText.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => RegisterPage()),
                        child: Text(
                          'Regístrate',
                          style: AppTextStyles.bodyText.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}