import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/ui/pages/proyecto_disponible_page.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/cards_wrapper.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/search_bar.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final searchController = TextEditingController();
  final List<String> activeFilters = [];

  bool showAvailable = true;

  List<ProjectInfo> get filteredProjects {
    final now = DateTime.now();

    return availableProjects.where((project) {
      final closingDate = _parseDate(project.closingDate);

      if (closingDate == null) {
        return false;
      }

      final endOfClosingDay = DateTime(
        closingDate.year,
        closingDate.month,
        closingDate.day,
        23,
        59,
        59,
      );

      final isAvailable = !now.isAfter(endOfClosingDay);

      // Disponibles o inspiración
      if (showAvailable && !isAvailable) {
        return false;
      }

      if (!showAvailable && isAvailable) {
        return false;
      }

      // Buscador
      if (activeFilters.isEmpty) {
        return true;
      }

      final searchableText = [
        project.name,
        project.leader,
        project.area,
        project.description,
        project.keywords,
        ...project.requirements,
        ...project.roles,
      ].join(' ').toLowerCase();

      return activeFilters.every(
        (filter) => searchableText.contains(
          filter.toLowerCase(),
        ),
      );
    }).toList();
  }

  DateTime? _parseDate(String value) {
    final parts = value.split('/');

    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return null;
    }

    return DateTime(year, month, day);
  }

  void _addFilter() {
    final value = searchController.text.trim().toLowerCase();

    if (value.isEmpty) return;

    if (!activeFilters.contains(value)) {
      setState(() {
        activeFilters.add(value);
      });
    }

    searchController.clear();
    FocusScope.of(context).unfocus();
  }

  void _removeFilter(String filter) {
    setState(() {
      activeFilters.remove(filter);
    });
  }

  void _clearAllFilters() {
    setState(() {
      activeFilters.clear();
    });

    searchController.clear();
  }

  void _changeProjectView(bool available) {
    setState(() {
      showAvailable = available;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visibleProjects = filteredProjects;

    return Container(
      color: scheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TÍTULO
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

              // DISPONIBLES / INSPIRACIÓN
              // ESTA PARTE QUEDA FIJA
              _ProjectViewSelector(
                showAvailable: showAvailable,
                onChanged: _changeProjectView,
              ),

              const SizedBox(height: 14),

              // BUSCADOR
              // ESTA PARTE QUEDA FIJA
              AppSearchBar(
                hintText: showAvailable
                    ? 'Buscar proyecto para participar'
                    : 'Buscar proyecto como inspiración',
                controller: searchController,
                onSubmitted: (_) => _addFilter(),
                onSuffixTap: _addFilter,
              ),

              // FILTROS ACTIVOS
              if (activeFilters.isNotEmpty) ...[
                const SizedBox(height: 10),
                _FilterList(
                  filters: activeFilters,
                  onRemove: _removeFilter,
                  onClear: _clearAllFilters,
                ),
              ],

              const SizedBox(height: 16),

              // ENCABEZADO DE RESULTADOS
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
                    '${visibleProjects.length}',
                    style: AppTextStyles.screenTitle.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // SOLO ESTA PARTE HACE SCROLL
              Expanded(
                child: visibleProjects.isEmpty
                    ? SingleChildScrollView(
                        child: _EmptyResults(
                          showAvailable: showAvailable,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        itemCount: visibleProjects.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          final project =
                              visibleProjects[index];

                          return _GroupCard(
                            project: project,
                            isAvailable: showAvailable,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectViewSelector extends StatelessWidget {
  final bool showAvailable;
  final ValueChanged<bool> onChanged;

  const _ProjectViewSelector({
    required this.showAvailable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(
          AppTheme.cardRadius,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SelectorButton(
              text: 'Disponibles',
              icon: Icons.groups_outlined,
              selected: showAvailable,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _SelectorButton(
              text: 'Inspiración',
              icon: Icons.lightbulb_outline,
              selected: !showAvailable,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectorButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SelectorButton({
    required this.text,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        AppTheme.smallRadius,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            AppTheme.smallRadius,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? scheme.onPrimary
                  : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: AppTextStyles.smallText.copyWith(
                color: selected
                    ? scheme.onPrimary
                    : scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterList extends StatelessWidget {
  final List<String> filters;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  const _FilterList({
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
      children: [
        ...filters.map(
          (filter) => Container(
            padding: const EdgeInsets.only(
              left: 14,
              right: 6,
              top: 7,
              bottom: 7,
            ),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(
                AppTheme.cardRadius,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filter,
                  style: AppTextStyles.smallText.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(
                    AppTheme.cardRadius,
                  ),
                  onTap: () => onRemove(filter),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onClear,
          icon: Icon(
            Icons.delete_outline,
            size: 18,
            color: scheme.primary,
          ),
          label: Text(
            'Limpiar',
            style: AppTextStyles.smallText.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(
          AppTheme.cardRadius,
        ),
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
            activeMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String get activeMessage {
    if (showAvailable) {
      return 'Prueba eliminando algún filtro.';
    }

    return 'Aquí aparecerán proyectos con convocatorias cerradas.';
  }
}

class _GroupCard extends StatelessWidget {
  final ProjectInfo project;
  final bool isAvailable;

  const _GroupCard({
    required this.project,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final information = {
      'Líder: ': project.leader,
      'Nombre: ': project.name,
      'Integrantes: ': project.members,
      'Vacantes: ': project.vacancies,
      'Fecha cierre: ': project.closingDate,
    };

    return CardWrapper(
      padding: const EdgeInsets.all(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProyectoDisponiblePage(
              project: project,
            ),
          ),
        );
      },
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
                    padding: const EdgeInsets.only(
                      bottom: 4,
                    ),
                    child: _InfoLine(
                      label: entry.key,
                      value: entry.value,
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

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyText.copyWith(
          color: scheme.onSurface,
        ),
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}