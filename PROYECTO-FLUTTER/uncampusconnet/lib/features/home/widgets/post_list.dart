import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/controllers/home_controller.dart';
import 'package:uncampusconnet/features/home/widgets/post_card.dart';

class PostList extends StatelessWidget {
  const PostList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    final controller =
        Get.find<HomeController>();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // =================================================
        // TÍTULO
        // =================================================

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Text(
            'Publicaciones:',
            style:
                AppTextStyles.sectionTitle
                    .copyWith(
              color: scheme.onSurface,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // =================================================
        // LISTA
        // =================================================

        Expanded(
          child: Obx(() {
            // -------------------------------------------------
            // CARGANDO
            // -------------------------------------------------

            if (controller
                .cargandoPublicaciones
                .value) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            // -------------------------------------------------
            // SIN PUBLICACIONES
            // -------------------------------------------------

            if (controller
                .sinPublicaciones) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    30,
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 42,
                        color:
                            scheme.onSurfaceVariant,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        'No hay publicaciones todavía.',
                        style:
                            AppTextStyles.bodyText
                                .copyWith(
                          color:
                              scheme.onSurfaceVariant,
                        ),
                        textAlign:
                            TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // -------------------------------------------------
            // PUBLICACIONES
            // -------------------------------------------------

            return ListView.separated(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 4,
              ),
              itemCount:
                  controller
                      .publicaciones
                      .length,
              separatorBuilder:
                  (_, __) =>
                      const SizedBox(
                    height: 18,
                  ),
              itemBuilder:
                  (context, index) {
                final post =
                    controller
                        .publicaciones[index];

                return PostCard(
                  key: ValueKey(post.idPublicacion),
                  post: post,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}