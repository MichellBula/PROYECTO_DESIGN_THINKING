import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/data/post_data.dart';
import 'package:uncampusconnet/features/home/controllers/home_controller.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';

class PostCard extends StatelessWidget {
  final PostData post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    final homeController =
        Get.find<HomeController>();

    return CardWrapper(
      onTap: () {
        showDevelopmentDialog(
          context,
        );
      },
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =================================================
          // ENCABEZADO
          // =================================================

          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    scheme.surfaceContainerHighest,
                child: Icon(
                  Icons.groups_outlined,
                  size: 18,
                  color:
                      scheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  post.nombreProyecto,
                  style:
                      AppTextStyles.authorName
                          .copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),

              Text(
                homeController
                    .tiempoDesdePublicacion(
                  post.fechaPublicacion,
                ),
                style:
                    AppTextStyles.caption
                        .copyWith(
                  color:
                      scheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.more_horiz,
                size: 20,
                color:
                    scheme.onSurfaceVariant,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =================================================
          // CONTENIDO
          // =================================================

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                post.titulo,
                style:
                    AppTextStyles.cardTitle
                        .copyWith(
                  color:
                      scheme.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                post.contenido,
                style:
                    AppTextStyles.bodyText
                        .copyWith(
                  color:
                      scheme.onSurfaceVariant,
                ),
                maxLines: 4,
                overflow:
                    TextOverflow.ellipsis,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =================================================
          // ACCIONES
          // =================================================

          Row(
            children: [
              // LIKE
              Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 20,
                    color:
                        scheme.onSurfaceVariant,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '${post.likes}',
                    style:
                        AppTextStyles.caption
                            .copyWith(
                      color:
                          scheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 18),

              // COMENTARIOS
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 20,
                    color:
                        scheme.onSurfaceVariant,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '${post.comentarios}',
                    style:
                        AppTextStyles.caption
                            .copyWith(
                      color:
                          scheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 18),

              // COMPARTIR
              Icon(
                Icons.share_outlined,
                size: 20,
                color:
                    scheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}