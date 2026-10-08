import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/profile/controllers/profile_controller.dart';
import 'package:uncampusconnet/features/profile/widgets/profile_header.dart';
import 'package:uncampusconnet/features/profile/widgets/profile_skills.dart';
import 'package:uncampusconnet/features/profile/widgets/profile_stats.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    final controller =
        Get.put(ProfileController());

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text(
          'Mi perfil',
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        // =================================================
        // CARGANDO
        // =================================================

        if (controller.cargando.value) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        // =================================================
        // ERROR
        // =================================================

        if (controller.error.value != null) {
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.all(30),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 45,
                    color:
                        scheme.onSurfaceVariant,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    controller.error.value!,
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color: scheme
                          .onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  FilledButton.icon(
                    onPressed:
                        controller.recargar,
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: const Text(
                      'Reintentar',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // =================================================
        // PERFIL
        // =================================================

        final profile =
            controller.perfil.value;

        if (profile == null) {
          return const SizedBox.shrink();
        }

        final initials =
            controller.obtenerIniciales(
          profile.nombreUsuario,
        );

        return RefreshIndicator(
          onRefresh:
              controller.recargar,
          child: ListView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              30,
            ),
            children: [
              // ===========================================
              // HEADER
              // ===========================================

              ProfileHeader(
                profile: profile,
                initials: initials,
              ),

              const SizedBox(
                height: 14,
              ),

              // ===========================================
              // ESTADISTICAS
              // ===========================================

              ProfileStats(
                profile: profile,
              ),

              const SizedBox(
                height: 18,
              ),

              // ===========================================
              // INFORMACION
              // ===========================================

              CardWrapper(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            scheme.onSurface,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    _InfoRow(
                      label: 'Carrera',
                      value:
                          profile.carrera,
                    ),

                    Divider(
                      color:
                          scheme.outlineVariant,
                    ),

                    _InfoRow(
                      label: 'Semestre',
                      value:
                          profile.semestre,
                    ),

                    Divider(
                      color:
                          scheme.outlineVariant,
                    ),

                    _InfoRow(
                      label:
                          'Correo institucional',
                      value: profile
                          .correoInstitucional,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              // ===========================================
              // HABILIDADES
              // ===========================================

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

// =========================================================
// FILA DE INFORMACION
// =========================================================

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 11,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
                color:
                    scheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            flex: 2,
            child: Text(
              value.isEmpty
                  ? 'No registrado'
                  : value,
              textAlign:
                  TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color:
                    scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}