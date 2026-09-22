import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';


class AppSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;   // ← NUEVO
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final IconData suffixIcon;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.onSubmitted,
    this.onChanged,   // ← NUEVO
    this.onSuffixTap,
    this.controller,
    this.suffixIcon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 38,
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.smallText.copyWith(color: scheme.onSurface),
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        onChanged: onChanged,   // ← NUEVO
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.smallText.copyWith(
            color: scheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          suffixIcon: IconButton(
            onPressed: onSuffixTap,
            icon: Icon(
              suffixIcon,
              size: 20,
              color: scheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}