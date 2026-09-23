import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/buscar/controllers/buscar_controller.dart';
import 'package:uncampusconnet/features/buscar/widgets/empty_results.dart';
import 'package:uncampusconnet/features/buscar/widgets/filter_chips.dart';
import 'package:uncampusconnet/features/buscar/widgets/project_buscar_card.dart';
import 'package:uncampusconnet/ui/widgets/search_bar.dart';
import 'package:uncampusconnet/ui/widgets/tab_selector.dart';

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
                  FilterChips(
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
                      ? EmptyResults(showAvailable: showAvailable)
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: projects.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 15),
                          itemBuilder: (_, index) => ProjectBuscarCard(
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
