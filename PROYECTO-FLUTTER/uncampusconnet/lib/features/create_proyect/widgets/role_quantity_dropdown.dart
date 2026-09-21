import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';

/// Dropdown especializado para seleccionar roles y definir
/// cuántas personas se necesitan para cada rol.
///
/// Funcionalidades:
/// - Selección de varios roles.
/// - Aumento y disminución de cantidades.
/// - Búsqueda de roles.
/// - Lista desplazable para muchos roles.
/// - Mantiene sincronización con el estado externo.
class RoleQuantityDropdown extends StatefulWidget {
  /// Lista de roles disponibles.
  final List<String> roles;

  /// Cantidad de personas por cada rol.
  final Map<String, int> quantities;

  /// Devuelve al widget padre las cantidades actualizadas.
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
  // ======================================================
  // OVERLAY
  // ======================================================

  /// Permite posicionar el menú debajo del campo.
  final LayerLink _layerLink = LayerLink();

  /// Overlay que contiene el menú.
  OverlayEntry? _overlayEntry;

  /// Controlador del buscador.
  final TextEditingController _searchController = TextEditingController();

  /// Copia local de las cantidades mientras el menú está abierto.
  Map<String, int> _localQuantities = {};

  /// Indica si el menú está abierto.
  bool get isOpen => _overlayEntry != null;

  // ======================================================
  // CICLO DE VIDA
  // ======================================================

  @override
  void dispose() {
    _searchController.dispose();
    _closeDropdown();
    super.dispose();
  }

  // ======================================================
  // ABRIR DROPDOWN
  // ======================================================

  /// Abre el menú y copia las cantidades actuales.
  void _openDropdown() {
    if (isOpen) return;

    // Creamos una copia para que el menú trabaje
    // con sus propios valores mientras está abierto.
    _localQuantities = Map<String, int>.from(widget.quantities);

    _searchController.clear();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // ==========================================
            // CERRAR AL TOCAR FUERA
            // ==========================================

            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox(),
              ),
            ),

            // ==========================================
            // MENÚ
            // ==========================================
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

  // ======================================================
  // CERRAR DROPDOWN
  // ======================================================

  /// Cierra el menú y limpia el buscador.
  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    _searchController.clear();

    if (mounted) {
      setState(() {});
    }
  }

  // ======================================================
  // CAMBIAR CANTIDAD
  // ======================================================

  /// Cambia la cantidad de personas de un rol.
  ///
  /// La cantidad mínima es 0.
  /// Cuando llega a 0, el rol deja de estar seleccionado.
  void _changeQuantity(String role, int change) {
    final int current = _localQuantities[role] ?? 0;

    final int newQuantity = (current + change).clamp(0, 99);

    // Actualizamos la copia local.
    if (newQuantity == 0) {
      _localQuantities.remove(role);
    } else {
      _localQuantities[role] = newQuantity;
    }

    // Enviamos el nuevo estado al padre / GetX.
    widget.onChanged(Map<String, int>.from(_localQuantities));

    // Refrescamos el contenido del Overlay.
    _overlayEntry?.markNeedsBuild();
  }

  // ======================================================
  // BÚSQUEDA
  // ======================================================

  /// Filtra los roles según el texto introducido.
  List<String> _filteredRoles() {
    final String query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.roles;
    }

    return widget.roles.where((role) {
      return role.toLowerCase().contains(query);
    }).toList();
  }

  // ======================================================
  // TEXTO DEL CAMPO
  // ======================================================

  /// Devuelve un resumen de los roles seleccionados.
  String _buildSelectedText() {
    if (widget.quantities.isEmpty) {
      return 'Puedes escoger uno o más roles';
    }

    final int totalRoles = widget.quantities.length;

    final int totalPeople = widget.quantities.values.fold(
      0,
      (sum, quantity) => sum + quantity,
    );

    return '$totalRoles roles seleccionados '
        '($totalPeople ${totalPeople == 1 ? 'persona' : 'personas'})';
  }

  // ======================================================
  // MENÚ
  // ======================================================

  /// Construye el contenido del menú desplegable.
  Widget _buildDropdownMenu() {
    final scheme = Theme.of(context).colorScheme;

    final List<String> filteredRoles = _filteredRoles();

    return Material(
      elevation: 6,

      color: scheme.surfaceContainer,

      borderRadius: BorderRadius.circular(AppTheme.smallRadius),

      child: SizedBox(
        height: 320,

        child: Column(
          children: [
            // ==========================================
            // BUSCADOR
            // ==========================================

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),

              child: TextField(
                controller: _searchController,

                autofocus: true,

                onChanged: (_) {
                  _overlayEntry?.markNeedsBuild();
                },

                style: AppTextStyles.smallText.copyWith(
                  color: scheme.onSurface,
                ),

                decoration: InputDecoration(
                  hintText: 'Buscar rol...',

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

                            _overlayEntry?.markNeedsBuild();
                          },
                          icon: const Icon(Icons.close, size: 18),
                        )
                      : null,

                  filled: true,

                  fillColor: scheme.surfaceContainerHighest,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.smallRadius),
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

            // ==========================================
            // LISTA DE ROLES
            // ==========================================
            Expanded(
              child: filteredRoles.isEmpty
                  ? Center(
                      child: Text(
                        'No se encontraron roles.',
                        style: AppTextStyles.smallText.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),

                      itemCount: filteredRoles.length,

                      itemBuilder: (context, index) {
                        final String role = filteredRoles[index];

                        final int quantity = _localQuantities[role] ?? 0;

                        final bool isSelected = quantity > 0;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),

                          decoration: BoxDecoration(
                            color: isSelected
                                ? scheme.primary.withValues(alpha: 0.06)
                                : Colors.transparent,
                          ),

                          child: Row(
                            children: [
                              // ==================================
                              // ROL
                              // ==================================

                              Expanded(
                                child: Text(
                                  role,

                                  maxLines: 2,

                                  overflow: TextOverflow.ellipsis,

                                  style: AppTextStyles.smallText.copyWith(
                                    color: scheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),

                              // ==================================
                              // MENOS
                              // ==================================
                              IconButton(
                                onPressed: quantity > 0
                                    ? () {
                                        _changeQuantity(role, -1);
                                      }
                                    : null,

                                icon: const Icon(Icons.remove, size: 18),

                                visualDensity: VisualDensity.compact,
                              ),

                              // ==================================
                              // CANTIDAD
                              // ==================================
                              Container(
                                width: 32,

                                alignment: Alignment.center,

                                child: Text(
                                  quantity.toString().padLeft(2, '0'),

                                  style: AppTextStyles.smallText.copyWith(
                                    color: scheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // ==================================
                              // MÁS
                              // ==================================
                              IconButton(
                                onPressed: () {
                                  _changeQuantity(role, 1);
                                },

                                icon: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: scheme.primary,
                                ),

                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // BUILD
  // ======================================================

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

        behavior: HitTestBehavior.opaque,

        child: Container(
          width: double.infinity,
          height: 38,

          padding: const EdgeInsets.symmetric(horizontal: 12),

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
    );
  }
}
