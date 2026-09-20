import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

/// Dropdown reutilizable para seleccionar varias opciones.
///
/// Permite:
/// - Abrir y cerrar un menú de opciones.
/// - Seleccionar una o varias opciones.
/// - Mostrar las opciones seleccionadas en el campo.
/// - Utilizarse tanto en modo claro como oscuro.
///
/// Este widget no maneja GetX directamente. Recibe los datos
/// y devuelve los cambios mediante [onChanged].
class MultiSelectDropdown extends StatefulWidget {
  /// Texto que se muestra cuando no hay opciones seleccionadas.
  final String hintText;

  /// Lista de opciones disponibles.
  final List<String> options;

  /// Lista de opciones seleccionadas actualmente.
  final List<String> selectedItems;

  /// Función ejecutada cuando cambia la selección.
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
  /// Indica si el menú de opciones está abierto.
  bool isOpen = false;

  // ======================================================
  // SELECCIÓN
  // ======================================================

  /// Agrega o elimina una opción de la lista seleccionada.
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
  // TEXTO MOSTRADO
  // ======================================================

  /// Genera el texto que se muestra dentro del campo.
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ==================================================
        // CAMPO PRINCIPAL
        // ==================================================

        GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
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
                // TEXTO
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

                // FLECHA
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
        // MENÚ DE OPCIONES
        // ==================================================
        if (isOpen)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 250),
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

            // Scroll interno para listas grandes
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final String option = widget.options[index];

                final bool isSelected = widget.selectedItems.contains(option);

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
                        // NOMBRE DE LA OPCIÓN
                        Expanded(
                          child: Text(
                            option,
                            style: AppTextStyles.smallText.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                        ),

                        // CHECKBOX
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
    );
  }
}
