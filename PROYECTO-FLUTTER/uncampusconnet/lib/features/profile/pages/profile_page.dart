import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/auth/pages/login_page.dart';
import 'package:uncampusconnet/features/profile/controllers/profile_controller.dart';
import 'package:uncampusconnet/features/profile/widgets/profile_header.dart';
import 'package:uncampusconnet/features/profile/widgets/profile_projects.dart';
import 'package:uncampusconnet/features/profile/widgets/profile_skills.dart';
import 'package:uncampusconnet/features/profile/widgets/profile_stats.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Mi perfil'),
        centerTitle: false,
      ),
      body: Obx(() {
        // CARGANDO
        if (controller.cargando.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ERROR
        if (controller.error.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 45,
                    color: scheme.onSurfaceVariant,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    controller.error.value!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyText.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 18),

                  FilledButton.icon(
                    onPressed: controller.recargar,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        // PERFIL
        final profile = controller.perfil.value;

        if (profile == null) {
          return const SizedBox.shrink();
        }

        final initials = controller.obtenerIniciales(
          profile.nombreUsuario,
        );

        return RefreshIndicator(
          onRefresh: controller.recargar,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            children: [
              // HEADER
              ProfileHeader(
                profile: profile,
                initials: initials,
                onLogout: () async {
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text(
                        '¿Estás seguro de que deseas cerrar sesión?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, true),
                          child: const Text('Cerrar sesión'),
                        ),
                      ],
                    ),
                  );

                  if (confirmar != true) return;

                  final sesion = Get.find<SesionController>();
                  await sesion.cerrarSesion();
                  Get.offAll(() => LoginPage());
                },
              ),

              const SizedBox(height: 14),

              // BIO (estatica por ahora)
              CardWrapper(
                child: Text(
                  'Estudiante interesado en tecnología, programación y análisis '
                  'de datos. Apasionado por los proyectos interdisciplinarios, '
                  'el trabajo en equipo y la creación de soluciones innovadoras.',
                  style: AppTextStyles.bodyText.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ESTADISTICAS
              ProfileStats(
                profile: profile,
              ),

              const SizedBox(height: 18),

              // PROYECTOS EN LOS QUE HE PARTICIPADO
              const ProfileProjects(),

              const SizedBox(height: 18),

              // HABILIDADES
              ProfileSkills(
                profile: profile,
              ),
            ],
          ),
        );
      }),
    );
  }
}