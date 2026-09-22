import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

/// Dropdown reutilizable para seleccionar una sola opción.
///
/// Al tocar el campo se abre un menú debajo del mismo.
/// A diferencia de `DropdownButton`, este widget mantiene el
/// menú dentro de la pantalla y permite desplazarse por las
/// opciones cuando la lista es extensa.
class ProjectDropdownField extends StatefulWidget {
  /// Etiqueta que aparece encima del campo.
  final String label;

  /// Texto mostrado cuando todavía no hay una selección.
  final String hint;

  /// Opción actualmente seleccionada.
  final String? value;

  /// Lista de opciones disponibles.
  final List<String> items;

  /// Se ejecuta cuando el usuario selecciona una opción.
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

  // ======================================================
  // SELECCIÓN
  // ======================================================

  /// Selecciona una opción y cierra el menú.
  void selectItem(String item) {
    widget.onChanged(item);

    setState(() {
      isOpen = false;
    });
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bool hasValue = widget.value != null;

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
        // CAMPO PRINCIPAL
        // ==================================================
        InkWell(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
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
                // TEXTO SELECCIONADO
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
        // MENÚ DESPLEGABLE
        // ==================================================
        if (isOpen)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 220),
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
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final String item = widget.items[index];

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
                          Icon(Icons.check, size: 18, color: scheme.primary),
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
