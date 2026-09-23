import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';

class EmptyResults extends StatelessWidget {
  final bool showAvailable;

  const EmptyResults({required this.showAvailable});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        child: Column(
          children: [
            Icon(
              showAvailable ? Icons.search_off : Icons.lightbulb_outline,
              size: 45,
              color: scheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              showAvailable
                  ? 'No encontramos proyectos disponibles'
                  : 'No encontramos proyectos anteriores',
              textAlign: TextAlign.center,
              style: AppTextStyles.screenTitle.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              showAvailable
                  ? 'Prueba eliminando algún filtro.'
                  : 'Aquí aparecerán proyectos con convocatorias cerradas.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
