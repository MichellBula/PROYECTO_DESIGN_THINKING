import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/widgets/event_card.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';



class HomeEvents extends StatelessWidget {
  const HomeEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SALUDO
            Text(
              'Hola, Juan!',
              style: AppTextStyles.greeting.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 2),
            Text(
              '¿Qué deseas hacer hoy?',
              style: AppTextStyles.subtitle.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),

            // TÍTULO + VER TODOS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Eventos próximos:',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () => showDevelopmentDialog(context),
                  child: Text(
                    'Ver todos',
                    style: AppTextStyles.smallText.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // CARRUSEL
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return EventCard(
                    event: events[index],
                    onTap: () => showDevelopmentDialog(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}