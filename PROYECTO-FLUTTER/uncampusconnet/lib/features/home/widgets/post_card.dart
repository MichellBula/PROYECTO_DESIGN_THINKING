import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/cards_wrapper.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int likes = widget.post.likes;
  late bool isLiked = widget.post.isLiked;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likes += isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return CardWrapper(
      onTap: () => showDevelopmentDialog(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ENCABEZADO
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: scheme.surfaceContainerHighest,
                child: Icon(Icons.person, size: 18, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.post.autor, style: AppTextStyles.authorName.copyWith(color: scheme.onSurface)),
                    Text(widget.post.usuario, style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Text(widget.post.tiempo, style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(width: 8),
              Icon(Icons.more_horiz, size: 20, color: scheme.onSurfaceVariant),
            ],
          ),

          const SizedBox(height: 12),

          // CONTENIDO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.post.titulo, style: AppTextStyles.cardTitle.copyWith(color: scheme.onSurface)),
                    const SizedBox(height: 4),
                    Text(
                      widget.post.contenido,
                      style: AppTextStyles.bodyText.copyWith(color: scheme.onSurfaceVariant),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (widget.post.imagen != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.post.imagen!,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 120,
                      height: 80,
                      color: scheme.surfaceContainerHighest,
                      child: Icon(Icons.image_not_supported, size: 30, color: scheme.onSurfaceVariant),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // ACCIONES
          Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: isLiked ? scheme.primary : scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$likes',
                      style: AppTextStyles.caption.copyWith(
                        color: isLiked ? scheme.primary : scheme.onSurface,
                        fontWeight: isLiked ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline, size: 20, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${widget.post.comentarios}', style: AppTextStyles.caption.copyWith(color: scheme.onSurface)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}