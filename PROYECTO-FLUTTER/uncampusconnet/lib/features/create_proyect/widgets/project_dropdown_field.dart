import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

/// Dropdown reutilizable para seleccionar una sola opción.
///
/// Permite buscar dentro de la lista antes de seleccionar.
/// Está pensado para categorías y tipos de proyecto.
class ProjectDropdownField extends StatefulWidget {
  /// Etiqueta del campo.
  final String label;

  /// Texto mostrado cuando no hay selección.
  final String hint;

  /// Valor seleccionado actualmente.
  final String? value;

  /// Opciones disponibles.
  final List<String> items;

  /// Se ejecuta cuando se selecciona una opción.
  final ValueChanged<String?> onChanged;

  const ProjectDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<ProjectDropdownField> createState() => _ProjectDropdownFieldState();
}

class _ProjectDropdownFieldState extends State<ProjectDropdownField> {
  /// Indica si el menú está abierto.
  bool isOpen = false;

  /// Controla el texto introducido en el buscador.
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ======================================================
  // SELECCIÓN
  // ======================================================

  /// Selecciona una opción y cierra el menú.
  void selectItem(String item) {
    widget.onChanged(item);

    setState(() {
      isOpen = false;
      _searchController.clear();
    });
  }

  // ======================================================
  // BÚSQUEDA
  // ======================================================

  /// Filtra las opciones según lo escrito.
  List<String> _filteredItems() {
    final String query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.items;
    }

    return widget.items.where((item) {
      return item.toLowerCase().contains(query);
    }).toList();
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bool hasValue = widget.value != null;

    final List<String> filteredItems = _filteredItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      mainAxisSize: MainAxisSize.min,

      children: [
        // ==================================================
        // ETIQUETA
        // ==================================================

        Text(
          widget.label,

          style: AppTextStyles.fieldLabel.copyWith(color: scheme.onSurface),
        ),

        const SizedBox(height: 6),

        // ==================================================
        // CAMPO
        // ==================================================
        InkWell(
          onTap: () {
            setState(() {
              isOpen = !isOpen;

              if (!isOpen) {
                _searchController.clear();
              }
            });
          },

          borderRadius: BorderRadius.circular(AppTheme.smallRadius),

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
                    hasValue ? widget.value! : widget.hint,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: AppTextStyles.smallText.copyWith(
                      color: hasValue
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

            constraints: const BoxConstraints(maxHeight: 260),

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
                // ==================================================
                // BUSCADOR
                // ==================================================

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
                      hintText: 'Buscar opción...',

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
                              onPressed: () {
                                _searchController.clear();

                                setState(() {});
                              },
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

                // ==================================================
                // RESULTADOS
                // ==================================================
                Expanded(
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'No se encontraron opciones.',
                              style: AppTextStyles.smallText.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),

                          itemCount: filteredItems.length,

                          itemBuilder: (context, index) {
                            final String item = filteredItems[index];

                            final bool isSelected = widget.value == item;

                            return InkWell(
                              onTap: () {
                                selectItem(item);
                              },

                              child: Container(
                                width: double.infinity,

                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),

                                color: isSelected
                                    ? scheme.primary.withValues(alpha: 0.10)
                                    : Colors.transparent,

                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,

                                        overflow: TextOverflow.ellipsis,

                                        style: AppTextStyles.smallText.copyWith(
                                          color: isSelected
                                              ? scheme.primary
                                              : scheme.onSurface,

                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),

                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        size: 18,
                                        color: scheme.primary,
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
