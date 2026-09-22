import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

//Selector de pestañas
class AppTabSelector extends StatelessWidget {
  /// Texto e icono de la primera opción
  final String firstLabel;
  final IconData firstIcon;

  /// Texto e icono de la segunda opción
  final String secondLabel;
  final IconData secondIcon;

  /// Estado: true = primera opción, false = segunda
  final bool isFirstSelected;

  /// Se ejecuta al cambiar de opción
  final ValueChanged<bool> onChanged;

  const AppTabSelector({
    super.key,
    required this.firstLabel,
    required this.firstIcon,
    required this.secondLabel,
    required this.secondIcon,
    required this.isFirstSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SelectorButton(
              text: firstLabel,
              icon: firstIcon,
              selected: isFirstSelected,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _SelectorButton(
              text: secondLabel,
              icon: secondIcon,
              selected: !isFirstSelected,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

//Boton interno
class _SelectorButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SelectorButton({
    required this.text,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: AppTextStyles.smallText.copyWith(
                color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}