import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

class MultiSelectDropdown extends StatefulWidget {
  final String hintText;
  final List<String> options;
  final List<String> selectedItems;
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
  bool isOpen = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleOption(String option) {
    final updatedItems = List<String>.from(widget.selectedItems);

    if (updatedItems.contains(option)) {
      updatedItems.remove(option);
    } else {
      updatedItems.add(option);
    }

    widget.onChanged(updatedItems);
  }

  List<String> _filteredOptions() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.options;
    }

    return widget.options
        .where(
          (option) => option.toLowerCase().contains(query),
        )
        .toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  String get _displayText {
    if (widget.selectedItems.isEmpty) {
      return widget.hintText;
    }

    return widget.selectedItems.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasSelection = widget.selectedItems.isNotEmpty;
    final filteredOptions = _filteredOptions();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              isOpen = !isOpen;

              if (!isOpen) {
                _searchController.clear();
              }
            });
          },
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 38),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(
                AppTheme.smallRadius,
              ),
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
                    _displayText,
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

        if (isOpen)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(
                AppTheme.smallRadius,
              ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
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
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                              ),
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
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          itemCount: filteredOptions.length,
                          itemBuilder: (context, index) {
                            final option = filteredOptions[index];

                            final isSelected =
                                widget.selectedItems.contains(option);

                            return InkWell(
                              onTap: () => _toggleOption(option),
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
                                      onChanged: (_) =>
                                          _toggleOption(option),
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