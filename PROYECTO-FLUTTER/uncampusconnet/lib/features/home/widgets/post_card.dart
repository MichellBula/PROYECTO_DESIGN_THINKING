import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/data/post_data.dart';
import 'package:uncampusconnet/features/home/controllers/home_controller.dart';
import 'package:uncampusconnet/features/home/controllers/post_interaction_controller.dart';
import 'package:uncampusconnet/features/home/widgets/post_detail_page.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';

class PostCard extends StatefulWidget {
  final PostData post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late PostInteractionController _interaction;

  @override
  void initState() {
    super.initState();
    _crearControlador();
  }

  void _crearControlador() {
    _interaction = PostInteractionController(
      post: widget.post,
    );

    _interaction.initialize().catchError(
      (Object e) {
        debugPrint(
          'Error cargando likes de la publicación '
          '${widget.post.idPublicacion}: $e',
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.post.idPublicacion !=
        widget.post.idPublicacion) {
      _crearControlador();
    }
  }

  // ==========================================================
  // ABRIR DETALLE DE PUBLICACIÓN
  // ==========================================================

  Future<void> _abrirDetalle({
    bool focusComposer = false,
  }) async {
    try {
      await _interaction.initialize();
    } catch (e) {
      debugPrint(
        'No se pudo inicializar la interacción: $e',
      );
    }

    if (!mounted) {
      return;
    }

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => PostDetailPage(
          post: widget.post,
          interaction: _interaction,
          focusComposer: focusComposer,
        ),
      ),
    );
  }

  // ==========================================================
  // DAR O QUITAR LIKE
  // ==========================================================

  Future<void> _toggleLike() async {
    try {
      await _interaction.toggleLike();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo actualizar el like: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final homeController = Get.find<HomeController>();

    return CardWrapper(
      onTap: () => _abrirDetalle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: scheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  widget.post.nombreProyecto,
                  style: AppTextStyles.authorName.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),

              Text(
                homeController.tiempoDesdePublicacion(
                  widget.post.fechaPublicacion,
                ),
                style: AppTextStyles.caption.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.more_horiz,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =================================================
          // TÍTULO
          // =================================================

          Text(
            widget.post.titulo,
            style: AppTextStyles.cardTitle.copyWith(
              color: scheme.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          // =================================================
          // VISTA PREVIA DEL CONTENIDO
          // =================================================

          Text(
            widget.post.contenido,
            style: AppTextStyles.bodyText.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // =================================================
          // ACCIONES
          // =================================================

          Row(
            children: [
              // =============================================
              // LIKE
              // =============================================

              Obx(
                () => IconButton(
                  tooltip:
                      _interaction.likedByCurrentUser.value
                          ? 'Quitar me gusta'
                          : 'Me gusta',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  onPressed:
                      _interaction.loading.value ||
                              _interaction.changingLike.value
                          ? null
                          : _toggleLike,
                  icon: Icon(
                    _interaction.likedByCurrentUser.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 21,
                    color:
                        _interaction.likedByCurrentUser.value
                            ? Colors.red
                            : scheme.onSurfaceVariant,
                  ),
                ),
              ),

              // CONTADOR DE LIKES

              Obx(
                () => Text(
                  '${_interaction.likesCount.value}',
                  style: AppTextStyles.caption.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(width: 18),

              // =============================================
              // COMENTARIOS
              // =============================================
              //
              // No necesita Obx porque el botón no depende
              // directamente de ninguna variable reactiva.
              //
              // =============================================

              IconButton(
                tooltip: 'Ver y escribir comentarios',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                onPressed: () => _abrirDetalle(
                  focusComposer: true,
                ),
                icon: Icon(
                  Icons.chat_bubble_outline,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
              ),

              // CONTADOR DE COMENTARIOS

              Obx(
                () => Text(
                  '${_interaction.commentsCount.value}',
                  style: AppTextStyles.caption.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(width: 18),

              // =============================================
              // COMPARTIR
              // =============================================

              Icon(
                Icons.share_outlined,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}