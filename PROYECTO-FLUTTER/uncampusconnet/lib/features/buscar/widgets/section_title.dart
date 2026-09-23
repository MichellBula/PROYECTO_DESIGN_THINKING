import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Text(
      title,
      style: AppTextStyles.screenTitle.copyWith(color: scheme.onSurface),
    );
  }
}
