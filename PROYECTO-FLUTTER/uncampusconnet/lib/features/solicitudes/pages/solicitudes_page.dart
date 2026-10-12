import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/solicitudes/controllers/solicitud_controller.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/project_solicitud_card.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/solicitud_simple_card.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';
import 'package:uncampusconnet/ui/widgets/search_bar.dart';
import 'package:uncampusconnet/ui/widgets/tab_selector.dart';

class SolicitudesPage extends StatefulWidget {
  const SolicitudesPage({super.key});

  @override
  State<SolicitudesPage> createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  late final SolicitudesController controller;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(SolicitudesController());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const AppScreenTitle(title: 'Solicitudes', showBackButton: false),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              AppSearchBar(
                hintText: 'Buscar por proyecto',
                controller: searchController,
                onChanged: controller.updateSearch,
                onSuffixTap: () {
                  controller.updateSearch(searchController.text);
                },
              ),

              const SizedBox(height: 14),

              Obx(
                () => AppTabSelector(
                  firstLabel: 'Recibidas',
                  firstIcon: Icons.inbox_outlined,
                  secondLabel: 'Enviadas',
                  secondIcon: Icons.send_outlined,
                  isFirstSelected: controller.selectedTab.value == 0,
                  onChanged: (value) {
                    controller.changeTab(value ? 0 : 1);
                  },
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),

        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return _buildErrorState(context, controller.errorMessage.value);
            }

            final isReceived = controller.selectedTab.value == 0;

            if (!isReceived) {
              final lista = controller.filteredList;

              if (lista.isEmpty) {
                return _buildEmptyState(
                  context,
                  'No se encontraron solicitudes',
                );
              }

              return RefreshIndicator(
                onRefresh: controller.cargarSolicitudes,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: lista.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return SolicitudSimpleCard(solicitud: lista[index]);
                  },
                ),
              );
            }

            final grouped = controller.groupedByProject;
            final proyectos = grouped.keys.toList();

            if (proyectos.isEmpty) {
              return _buildEmptyState(context, 'No se encontraron solicitudes');
            }

            return RefreshIndicator(
              onRefresh: controller.cargarSolicitudes,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: proyectos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final proyecto = proyectos[index];

                  return ProyectoSolicitudesCard(
                    proyecto: proyecto,
                    solicitudes: grouped[proyecto]!,
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String mensaje) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: controller.cargarSolicitudes,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String mensaje) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'No fue posible cargar las solicitudes',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: controller.cargarSolicitudes,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
