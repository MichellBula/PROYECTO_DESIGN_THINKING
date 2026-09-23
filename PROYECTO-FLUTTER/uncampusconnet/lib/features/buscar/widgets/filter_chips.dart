import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';

class FilterChips extends StatelessWidget {
  final List<String> filters;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  const FilterChips({
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
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...filters.map(
          (filter) => InputChip(
            label: Text(filter, style: AppTextStyles.smallText),
            onDeleted: () => onRemove(filter),
            backgroundColor: scheme.primaryContainer,
            deleteIconColor: scheme.onPrimaryContainer,
            side: BorderSide.none,
          ),
        ),
        TextButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Limpiar'),
        ),
      ],
    );
  }
}
