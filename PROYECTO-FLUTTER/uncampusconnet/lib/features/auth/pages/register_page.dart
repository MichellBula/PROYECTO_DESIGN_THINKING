import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/auth/pages/completar_perfil_page.dart';
import 'package:uncampusconnet/ui/widgets/text_field.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = Get.put(SesionController());

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Validación de campos vacíos
    if (nameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        passCtrl.text.trim().isEmpty ||
        confirmPassCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Campos vacíos',
        'Por favor completa todos los campos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validar que las contraseñas coincidan
    if (passCtrl.text.trim() != confirmPassCtrl.text.trim()) {
      Get.snackbar(
        'Contraseñas no coinciden',
        'Las contraseñas deben ser iguales',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validar longitud mínima de la contraseña
    if (passCtrl.text.trim().length < 6) {
      Get.snackbar(
        'Contraseña corta',
        'La contraseña debe tener al menos 6 caracteres',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final ok = await controller.registrarCuenta(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
        name: nameCtrl.text.trim(),
      );

      if (!ok || !mounted) return;

      // Después de registrarse → completar perfil
      Get.offAll(() => const CompletarPerfilPage());
    } catch (e) {
      // DEBUG: imprime el error real en la consola
      print('ERROR AL REGISTRAR: $e');

      Get.snackbar(
        'Error',
        'No se pudo crear la cuenta: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: scheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),

                // TÍTULO
                Text(
                  'Crear cuenta',
                  style: AppTextStyles.greeting.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Completa tus datos para registrarte',
                  style: AppTextStyles.subtitle.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 30),

                // NOMBRE
                AppTextField(
                  label: 'Nombre completo',
                  hint: 'Tu nombre',
                  controller: nameCtrl,
                  maxLength: 50,
                ),
                const SizedBox(height: 16),

                // EMAIL
                AppTextField(
                  label: 'Email',
                  hint: 'tu@correo.com',
                  controller: emailCtrl,
                  maxLength: 100,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // CONTRASEÑA
                AppTextField(
                  label: 'Contraseña',
                  hint: '••••••••',
                  controller: passCtrl,
                  maxLength: 50,
                  isPassword: true,
                ),
                const SizedBox(height: 16),

                // CONFIRMAR CONTRASEÑA
                AppTextField(
                  label: 'Confirmar contraseña',
                  hint: '••••••••',
                  controller: confirmPassCtrl,
                  maxLength: 50,
                  isPassword: true,
                ),
                const SizedBox(height: 30),

                // BOTÓN REGISTRARSE
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.cargando.value ? null : _register,
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
                              'Registrarse',
                              style: AppTextStyles.buttonText,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}