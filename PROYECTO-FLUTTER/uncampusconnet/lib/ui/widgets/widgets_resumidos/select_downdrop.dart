import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

/// Dropdown para seleccionar múltiples opciones.
///
/// Está pensado principalmente para la selección de habilidades,
/// aunque puede reutilizarse para cualquier lista múltiple.
///
/// También incluye búsqueda dentro del menú.
class MultiSelectDropdown extends StatefulWidget {
  /// Texto mostrado cuando no hay opciones seleccionadas.
  final String hintText;

  /// Opciones disponibles.
  final List<String> options;

  /// Opciones seleccionadas actualmente.
  final List<String> selectedItems;

  /// Devuelve la nueva lista de opciones seleccionadas.
  final ValueChanged<List<String>> onChanged;

  const MultiSelectDropdown({
    super.key,
    required this.hintText,
    required this.options,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  /// Indica si el menú está abierto.
  bool isOpen = false;

  /// Controla el texto de búsqueda.
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ======================================================
  // SELECCIÓN
  // ======================================================

  /// Agrega o elimina una opción.
  void toggleOption(String option) {
    final List<String> updatedItems = List<String>.from(widget.selectedItems);

    if (updatedItems.contains(option)) {
      updatedItems.remove(option);
    } else {
      updatedItems.add(option);
    }

    widget.onChanged(updatedItems);
  }

  // ======================================================
  // BÚSQUEDA
  // ======================================================

  /// Filtra las opciones según lo escrito.
  List<String> _filteredOptions() {
    final String query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.options;
    }

    return widget.options.where((option) {
      return option.toLowerCase().contains(query);
    }).toList();
  }

  /// Limpia la búsqueda.
  void _clearSearch() {
    _searchController.clear();

    setState(() {});
  }

  // ======================================================
  // TEXTO MOSTRADO
  // ======================================================

  String get displayText {
    if (widget.selectedItems.isEmpty) {
      return widget.hintText;
    }

    return widget.selectedItems.join(', ');
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bool hasSelection = widget.selectedItems.isNotEmpty;

    final List<String> filteredOptions = _filteredOptions();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ==================================================
        // ETIQUETA / CAMPO
        // ==================================================

        GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;

              if (!isOpen) {
                _searchController.clear();
              }
            });
          },

          behavior: HitTestBehavior.opaque,

          child: Container(
            width: double.infinity,

            constraints: const BoxConstraints(minHeight: 38),

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,

              borderRadius: BorderRadius.circular(AppTheme.smallRadius),

              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: AppTextStyles.smallText.copyWith(
                      color: hasSelection
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,

                  size: 22,

                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),

        // ==================================================
        // MENÚ
        // ==================================================
        if (isOpen)
          Container(
            width: double.infinity,

            margin: const EdgeInsets.only(top: 4),

            constraints: const BoxConstraints(maxHeight: 300),

            decoration: BoxDecoration(
              color: scheme.surfaceContainer,

              borderRadius: BorderRadius.circular(AppTheme.smallRadius),

              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.20),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // BUSCADOR
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),

                  child: TextField(
                    controller: _searchController,

                    autofocus: true,

                    onChanged: (_) {
                      setState(() {});
                    },

                    style: AppTextStyles.smallText.copyWith(
                      color: scheme.onSurface,
                    ),

                    decoration: InputDecoration(
                      hintText: 'Buscar habilidad...',

                      hintStyle: AppTextStyles.smallText.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),

                      prefixIcon: Icon(
                        Icons.search,
                        size: 19,
                        color: scheme.onSurfaceVariant,
                      ),

                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.close, size: 18),
                            )
                          : null,

                      filled: true,

                      fillColor: scheme.surfaceContainerHighest,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.smallRadius,
                        ),
                        borderSide: BorderSide.none,
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),

                const Divider(height: 1),

                // RESULTADOS
                Expanded(
                  child: filteredOptions.isEmpty
                      ? Center(
                          child: Text(
                            'No se encontraron habilidades.',
                            style: AppTextStyles.smallText.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),

                          itemCount: filteredOptions.length,

                          itemBuilder: (context, index) {
                            final String option = filteredOptions[index];

                            final bool isSelected = widget.selectedItems
                                .contains(option);

                            return InkWell(
                              onTap: () {
                                toggleOption(option);
                              },

                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),

                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,

                                        style: AppTextStyles.smallText.copyWith(
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                    ),

                                    Checkbox(
                                      value: isSelected,

                                      activeColor: scheme.primary,

                                      checkColor: scheme.onPrimary,

                                      onChanged: (_) {
                                        toggleOption(option);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
