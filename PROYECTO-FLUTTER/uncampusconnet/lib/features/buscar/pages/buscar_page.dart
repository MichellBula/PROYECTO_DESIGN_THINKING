import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/buscar/controllers/buscar_controller.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';
import 'package:uncampusconnet/features/buscar/pages/proyecto_disponible_page.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/cards_wrapper.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/search_bar.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/tab_selector.dart';

class BuscarPage extends StatelessWidget {
  const BuscarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final BuscarController controller = Get.isRegistered<BuscarController>()
        ? Get.find<BuscarController>()
        : Get.put(BuscarController());

    return Container(
      color: scheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Obx(() {
            final projects = controller.visibleProjects;
            final showAvailable = controller.showAvailable.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 52,
                  child: Center(
                    child: Text(
                      '¡Encuentra proyectos!',
                      style: AppTextStyles.screenTitle.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ),

                const Divider(),
                const SizedBox(height: 16),

                AppTabSelector(
                  firstLabel: 'Disponibles',
                  firstIcon: Icons.groups_outlined,
                  secondLabel: 'Inspiración',
                  secondIcon: Icons.lightbulb_outline,
                  isFirstSelected: showAvailable,
                  onChanged: controller.changeView,
                ),

                const SizedBox(height: 14),

                AppSearchBar(
                  hintText: showAvailable
                      ? 'Buscar proyecto para participar'
                      : 'Buscar proyecto como inspiración',
                  controller: controller.searchController,
                  onSubmitted: (_) {
                    controller.addFilter();
                    FocusScope.of(context).unfocus();
                  },
                  onSuffixTap: () {
                    controller.addFilter();
                    FocusScope.of(context).unfocus();
                  },
                ),

                if (controller.filters.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _FilterChips(
                    filters: controller.filters,
                    onRemove: controller.removeFilter,
                    onClear: controller.clearFilters,
                  ),
                ],

                const SizedBox(height: 16),

                Row(
                  children: [
                    Text(
                      showAvailable
                          ? 'Proyectos disponibles:'
                          : 'Proyectos anteriores:',
                      style: AppTextStyles.screenTitle.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${projects.length}',
                      style: AppTextStyles.screenTitle.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: projects.isEmpty
                      ? _EmptyResults(
                          showAvailable: showAvailable,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: projects.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 15),
                          itemBuilder: (_, index) => _ProjectCard(
                            project: projects[index],
                            isAvailable: showAvailable,
                          ),
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<String> filters;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  const _FilterChips({
    required this.filters,
    required this.onRemove,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...filters.map(
          (filter) => InputChip(
            label: Text(
              filter,
              style: AppTextStyles.smallText,
            ),
            onDeleted: () => onRemove(filter),
            backgroundColor: scheme.primaryContainer,
            deleteIconColor: scheme.onPrimaryContainer,
            side: BorderSide.none,
          ),
        ),
        TextButton.icon(
          onPressed: onClear,
          icon: const Icon(
            Icons.delete_outline,
            size: 18,
          ),
          label: const Text('Limpiar'),
        ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final bool showAvailable;

  const _EmptyResults({
    required this.showAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 35,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        child: Column(
          children: [
            Icon(
              showAvailable
                  ? Icons.search_off
                  : Icons.lightbulb_outline,
              size: 45,
              color: scheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              showAvailable
                  ? 'No encontramos proyectos disponibles'
                  : 'No encontramos proyectos anteriores',
              textAlign: TextAlign.center,
              style: AppTextStyles.screenTitle.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              showAvailable
                  ? 'Prueba eliminando algún filtro.'
                  : 'Aquí aparecerán proyectos con convocatorias cerradas.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectInfo project;
  final bool isAvailable;

  const _ProjectCard({
    required this.project,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final information = {
      'Líder': project.leader,
      'Nombre': project.name,
      'Integrantes': project.members,
      'Vacantes': project.vacancies,
      'Fecha cierre': project.closingDate,
    };

    return CardWrapper(
      padding: const EdgeInsets.all(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProyectoDisponiblePage(
            project: project,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...information.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodyText.copyWith(
                          color: scheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: '${entry.key}: ',
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text: entry.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (!isAvailable) ...[
                  const SizedBox(height: 5),
                  Text(
                    'Convocatoria cerrada',
                    style: AppTextStyles.smallText.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}