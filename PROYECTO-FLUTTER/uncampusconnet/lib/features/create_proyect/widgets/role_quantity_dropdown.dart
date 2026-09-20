import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';

/// Dropdown especializado para seleccionar roles y la cantidad
/// de personas necesarias para cada rol.
///
/// Un rol se considera seleccionado cuando su cantidad es mayor
/// que cero.
///
/// Ejemplo:
///
/// {
///   'Programador': 2,
///   'Diseñador': 1,
/// }
class RoleQuantityDropdown extends StatefulWidget {
  /// Roles disponibles para seleccionar.
  final List<String> roles;

  /// Cantidad actual de personas por cada rol.
  ///
  /// Ejemplo:
  /// {
  ///   'Programador': 2,
  ///   'Diseñador': 1,
  /// }
  final Map<String, int> quantities;

  /// Se ejecuta cada vez que cambia alguna cantidad.
  final ValueChanged<Map<String, int>> onChanged;

  const RoleQuantityDropdown({
    super.key,
    required this.roles,
    required this.quantities,
    required this.onChanged,
  });

  @override
  State<RoleQuantityDropdown> createState() => _RoleQuantityDropdownState();
}

class _RoleQuantityDropdownState extends State<RoleQuantityDropdown> {
  /// Permite posicionar el menú desplegable debajo del campo.
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  bool get isOpen => _overlayEntry != null;

  // ======================================================
  // ABRIR / CERRAR DROPDOWN
  // ======================================================

  /// Abre el menú desplegable.
  void _openDropdown() {
    if (isOpen) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Permite cerrar el menú tocando fuera.
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox(),
              ),
            ),

            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                color: Colors.transparent,
                child: SizedBox(width: size.width, child: _buildDropdownMenu()),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    setState(() {});
  }

  /// Cierra el menú desplegable.
  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted) {
      setState(() {});
    }
  }

  // ======================================================
  // CAMBIAR CANTIDAD
  // ======================================================

  /// Incrementa o reduce la cantidad de personas de un rol.
  ///
  /// Si la cantidad llega a cero, el rol deja de estar
  /// seleccionado.
  void _changeQuantity(String role, int change) {
    final Map<String, int> updated = Map<String, int>.from(widget.quantities);

    final int current = updated[role] ?? 0;

    final int newQuantity = (current + change).clamp(0, 99);

    if (newQuantity == 0) {
      updated.remove(role);
    } else {
      updated[role] = newQuantity;
    }

    widget.onChanged(updated);

    // Actualizamos el contenido del Overlay.
    _overlayEntry?.markNeedsBuild();
  }

  // ======================================================
  // TEXTO DEL CAMPO
  // ======================================================

  /// Genera el texto que aparece cuando el dropdown está cerrado.
  String _buildSelectedText() {
    if (widget.quantities.isEmpty) {
      return 'Puedes escoger uno o más roles';
    }

    return widget.quantities.entries
        .map((entry) => '${entry.key} (${entry.value})')
        .join(', ');
  }

  // ======================================================
  // BUILD DEL MENÚ
  // ======================================================

  Widget _buildDropdownMenu() {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 6,
      color: scheme.surfaceContainer,
      borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 6),
          shrinkWrap: true,
          itemCount: widget.roles.length,
          itemBuilder: (context, index) {
            final String role = widget.roles[index];

            final int quantity = widget.quantities[role] ?? 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      role,
                      style: AppTextStyles.smallText.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),

                  // MENOS
                  IconButton(
                    onPressed: quantity > 0
                        ? () => _changeQuantity(role, -1)
                        : null,
                    icon: const Icon(Icons.remove, size: 18),
                    visualDensity: VisualDensity.compact,
                  ),

                  // CANTIDAD
                  SizedBox(
                    width: 28,
                    child: Center(
                      child: Text(
                        quantity.toString().padLeft(2, '0'),
                        style: AppTextStyles.smallText.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // MÁS
                  IconButton(
                    onPressed: () => _changeQuantity(role, 1),
                    icon: Icon(Icons.add, size: 18, color: scheme.primary),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bool hasSelection = widget.quantities.isNotEmpty;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (isOpen) {
            _closeDropdown();
          } else {
            _openDropdown();
          }
        },
        child: Container(
          height: 38,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.smallRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _buildSelectedText(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.smallText.copyWith(
                    color: hasSelection
                        ? scheme.onSurface
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ),

              Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 22,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
