import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';

class AppScreenTitle extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool showDivider;

  const AppScreenTitle({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),   // ← padding lateral
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: Row(
              children: [
                if (showBackButton)
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: scheme.onSurface,
                    ),
                  )
                else
                  const SizedBox(width: 28),

                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: AppTextStyles.screenTitle.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 28),
              ],
            ),
          ),

          // LÍNEA DIVISORIA
          if (showDivider) const Divider(),
        ],
      ),
    );
  }
}