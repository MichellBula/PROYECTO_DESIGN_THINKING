import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/usuario/controllers/usuario_controller.dart';
import 'package:uncampusconnet/ui/widgets/main_scaffold.dart';
import 'package:uncampusconnet/ui/widgets/text_field.dart';

class CompletarPerfilPage extends StatefulWidget {
  const CompletarPerfilPage({super.key});

  @override
  State<CompletarPerfilPage> createState() => _CompletarPerfilPageState();
}

class _CompletarPerfilPageState extends State<CompletarPerfilPage> {
  final sesionController = Get.find<SesionController>();
  final usuarioController = Get.put(UsuarioController());

  final carreraCtrl = TextEditingController();
  final semestreCtrl = TextEditingController();

  @override
  void dispose() {
    carreraCtrl.dispose();
    semestreCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarPerfil() async {
    // Validar carrera
    if (carreraCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Campo vacío',
        'Por favor ingresa tu carrera',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validar semestre
    final semestre = int.tryParse(semestreCtrl.text.trim());
    if (semestre == null || semestre < 1 || semestre > 12) {
      Get.snackbar(
        'Semestre inválido',
        'Ingresa un semestre entre 1 y 12',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Obtener usuario autenticado
    final authUser = sesionController.usuarioAutenticado.value;
    if (authUser == null) {
      Get.snackbar(
        'Error',
        'No hay sesión activa',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Crear el perfil en Roble
      final perfil = await usuarioController.crearPerfil(
        nombreUsuario: authUser.name,
        correoInstitucional: authUser.email,
        carrera: carreraCtrl.text.trim(),
        semestre: semestre,
        idAutenticador: authUser.userId,
      );

      // Actualizar el perfil en SesionController
      sesionController.perfilUsuario.value = perfil;

      if (!mounted) return;

      // Va al home
      Get.offAll(() => const MainScaffold());
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo guardar el perfil. Intenta de nuevo.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final authUser = sesionController.usuarioAutenticado.value;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // TÍTULO
                Text(
                  'Completa tu perfil',
                  style: AppTextStyles.greeting.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Solo un paso más para empezar',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),

                // INFO DEL USUARIO (solo lectura)
                if (authUser != null) ...[
                  _ReadOnlyField(
                    label: 'Nombre',
                    value: authUser.name,
                  ),
                  const SizedBox(height: 16),
                  _ReadOnlyField(
                    label: 'Email',
                    value: authUser.email,
                  ),
                  const SizedBox(height: 20),
                ],

                // CARRERA
                AppTextField(
                  label: 'Carrera',
                  hint: 'Ej: Ingeniería de sistemas',
                  controller: carreraCtrl,
                  maxLength: 100,
                ),
                const SizedBox(height: 16),

                // SEMESTRE
                AppTextField(
                  label: 'Semestre',
                  hint: 'Ej: 6',
                  controller: semestreCtrl,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),

                // BOTÓN GUARDAR
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: usuarioController.cargando.value
                          ? null
                          : _guardarPerfil,
                      child: usuarioController.cargando.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Guardar y continuar',
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

//Campo de informacion
class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),

        // VALOR (sin edición)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppTheme.smallRadius),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyText.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}