import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/solicitudes/controllers/solicitud_controller.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/project_solicitud_card.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/solicitud_simple_card.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/screen_title.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/search_bar.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/tab_selector.dart';

class SolicitudesPage extends StatelessWidget {
  const SolicitudesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SolicitudesController());
    final searchController = TextEditingController();

    return Column(
      children: [
        // TÍTULO (sin flecha atrás)
        const AppScreenTitle(
          title: 'Solicitudes',
          showBackButton: false,
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              // BARRA DE BÚSQUEDA
              AppSearchBar(
                hintText: 'Buscar por proyecto',
                controller: searchController,
                onChanged: (value) {
                  controller.updateSearch(value);
                },
                onSuffixTap: () {
                  controller.updateSearch(searchController.text);
                },
              ),

              const SizedBox(height: 14),

              // TABS
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

        // LISTA
        Expanded(
          child: Obx(
            () {
              final isReceived = controller.selectedTab.value == 0;

              // ENVIADAS
              if (!isReceived) {
                final lista = controller.filteredList;

                if (lista.isEmpty) {
                  return Center(
                    child: Text(
                      'No se encontraron solicitudes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: lista.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return SolicitudSimpleCard(solicitud: lista[index]);
                  },
                );
              }

              // RECIBIDAS
              final grouped = controller.groupedByProject;
              final proyectos = grouped.keys.toList();

              if (proyectos.isEmpty) {
                return Center(
                  child: Text(
                    'No se encontraron solicitudes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: proyectos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final proyecto = proyectos[index];
                  return ProyectoSolicitudesCard(
                    proyecto: proyecto,
                    solicitudes: grouped[proyecto]!,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}