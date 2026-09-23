import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/controllers/home_controller.dart';
import 'package:uncampusconnet/features/home/widgets/event_card.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';

class HomeEvents extends StatelessWidget {
  const HomeEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.put(HomeController());

    return Container(
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SALUDO
            Obx(
              () => Text(
                'Hola, ${controller.nombreUsuario.value}!',
                style: AppTextStyles.greeting.copyWith(
                  color: scheme.onSurface,
                ),
              ),
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

            // CONTENIDO
            SizedBox(
              height: 140,
              child: Obx(() {
                // CARGANDO
                if (controller.cargando.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // SIN EVENTOS
                if (controller.sinEventos) {
                  return _EmptyEvents(scheme: scheme);
                }

                // CARRUSEL
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.eventos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return EventCard(
                      event: controller.eventos[index],
                      onTap: () => showDevelopmentDialog(context),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyEvents extends StatelessWidget {
  final ColorScheme scheme;

  const _EmptyEvents({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 36,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            'No hay eventos próximos',
            style: AppTextStyles.bodyText.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}