import 'package:flutter/material.dart';
import 'package:uncampusconnet/ui/pages/proyecto_disponible_page.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final searchController = TextEditingController();
  final List<String> activeFilters = [];

  List<ProjectInfo> get filteredProjects {
    if (activeFilters.isEmpty) return availableProjects;

    return availableProjects.where((project) {
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
        (filter) => searchableText.contains(filter.toLowerCase()),
      );
    }).toList();
  }

  void _addFilter() {
    final value = searchController.text.trim().toLowerCase();
    if (value.isEmpty) return;

    if (!activeFilters.contains(value)) {
      setState(() => activeFilters.add(value));
    }

    searchController.clear();
    FocusScope.of(context).unfocus();
  }

  void _removeFilter(String filter) =>
      setState(() => activeFilters.remove(filter));

  void _clearAllFilters() {
    setState(activeFilters.clear);
    searchController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final textColor =
        isDarkMode ? Colors.white : const Color(0xFF0A0A0A);

    final visibleProjects = filteredProjects;

    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 52,
              child: Center(
                child: Text(
                  '¡Encuentra proyectos disponibles!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),

            Divider(
              height: 1,
              color: isDarkMode
                  ? const Color(0xFF333333)
                  : const Color(0xFFD9D9D9),
            ),

            const SizedBox(height: 20),

            _SearchBar(
              controller: searchController,
              onSearch: _addFilter,
            ),

            if (activeFilters.isNotEmpty) ...[
              const SizedBox(height: 14),
              _FilterList(
                filters: activeFilters,
                onRemove: _removeFilter,
                onClear: _clearAllFilters,
              ),
            ],

            const SizedBox(height: 25),

            Row(
              children: [
                Text(
                  'Grupos disponibles:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${visibleProjects.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF500000),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            if (visibleProjects.isEmpty)
              _EmptyResults(
                isDarkMode: isDarkMode,
                textColor: textColor,
              )
            else
              ...visibleProjects.map(
                (project) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _GroupCard(project: project),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const _SearchBar({
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Color(0xFF0A0A0A)),
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => onSearch(),
        decoration: InputDecoration(
          hintText: 'Buscar proyecto o categoría',
          hintStyle: const TextStyle(color: Color(0xFF6B6B6B)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            tooltip: 'Agregar filtro',
            icon: const Icon(
              Icons.search,
              color: Color(0xFF500000),
            ),
            onPressed: onSearch,
          ),
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
              color: const Color(0xFFC9ACAC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filter,
                  style: const TextStyle(
                    color: Color(0xFF500000),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onRemove(filter),
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Color(0xFF500000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onClear,
          icon: const Icon(
            Icons.delete_outline,
            size: 18,
            color: Color(0xFF931212),
          ),
          label: const Text(
            'Limpiar',
            style: TextStyle(
              color: Color(0xFF931212),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final bool isDarkMode;
  final Color textColor;

  const _EmptyResults({
    required this.isDarkMode,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off,
            size: 45,
            color: Color(0xFF931212),
          ),
          const SizedBox(height: 10),
          Text(
            'No encontramos proyectos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Prueba eliminando algún filtro.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isDarkMode
                  ? Colors.white70
                  : const Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final ProjectInfo project;

  const _GroupCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor =
        isDarkMode ? Colors.white : const Color(0xFF0A0A0A);
    final secondaryTextColor =
        isDarkMode ? Colors.white70 : const Color(0xFF6B6B6B);

    final information = {
      'Líder: ': project.leader,
      'Nombre: ': project.name,
      'Integrantes: ': project.members,
      'Vacantes: ': project.vacancies,
      'Fecha cierre: ': project.closingDate,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFF500000),
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: information.entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _InfoLine(
                        label: entry.key,
                        value: entry.value,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          IconButton(
            tooltip: 'Ver proyecto',
            icon: Icon(
              Icons.more_vert,
              size: 28,
              color: textColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProyectoDisponiblePage(
                    project: project,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color secondaryTextColor;

  const _InfoLine({
    required this.label,
    required this.value,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
        children: [
          TextSpan(
            text: label,
            style: TextStyle(color: secondaryTextColor),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}