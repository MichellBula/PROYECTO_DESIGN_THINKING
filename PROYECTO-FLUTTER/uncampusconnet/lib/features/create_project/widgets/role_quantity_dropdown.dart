import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';

/// Dropdown especializado para seleccionar roles y definir
/// cuántas personas se necesitan para cada rol.
class RoleQuantityDropdown extends StatefulWidget {
  final List<String> roles;
  final Map<String, int> quantities;
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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();
  Map<String, int> _localQuantities = {};

  bool get isOpen => _overlayEntry != null;

  @override
  void dispose() {
    // Primero cerramos de forma segura y luego destruimos
    _closeDropdown();
    _searchController.dispose();
    super.dispose();
  }

  void _openDropdown() {
    if (isOpen) return;

    _localQuantities = Map<String, int>.from(widget.quantities);
    _searchController.clear();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
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

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    // Si la pantalla ya se está destruyendo, no hacemos NADA.
    if (!mounted) return;

    try {
      _searchController.clear();
    } catch (_) {
      // Ignoramos si el controlador ya fue destruido
    }

    setState(() {});
  }

  void _changeQuantity(String role, int change) {
    final int current = _localQuantities[role] ?? 0;
    final int newQuantity = (current + change).clamp(0, 99);

    if (newQuantity == 0) {
      _localQuantities.remove(role);
    } else {
      _localQuantities[role] = newQuantity;
    }

    widget.onChanged(Map<String, int>.from(_localQuantities));
    _overlayEntry?.markNeedsBuild();
  }

  List<String> _filteredRoles() {
    final String query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return widget.roles;

    return widget.roles.where((role) {
      return role.toLowerCase().contains(query);
    }).toList();
  }

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
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) {
                  _overlayEntry?.markNeedsBuild();
                },
                style: AppTextStyles.smallText.copyWith(color: scheme.onSurface),
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
                              IconButton(
                                onPressed: quantity > 0
                                    ? () {
                                        _changeQuantity(role, -1);
                                      }
                                    : null,
                                icon: const Icon(Icons.remove, size: 18),
                                visualDensity: VisualDensity.compact,
                              ),
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