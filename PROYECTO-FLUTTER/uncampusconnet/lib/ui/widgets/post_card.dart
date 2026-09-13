import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/home_data.dart';

// ======================================================
// TARJETA DE PUBLICACIÓN
// ======================================================

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int likes;
  late bool isLiked;

  @override
  void initState() {
    super.initState();

    likes = widget.post.likes;
    isLiked = widget.post.isLiked;
  }

  // ====================================================
  // CAMBIAR LIKE
  // ====================================================

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        likes--;
        isLiked = false;
      } else {
        likes++;
        isLiked = true;
      }
    });
  }

  // ====================================================
  // BUILD
  // ====================================================

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color cardColor =
        isDarkMode
            ? const Color(0xFF242424)
            : Colors.white;

    final Color primaryTextColor =
        isDarkMode
            ? Colors.white
            : Colors.black;

    final Color secondaryTextColor =
        isDarkMode
            ? Colors.white70
            : Colors.grey[700]!;

    final Color mutedTextColor =
        isDarkMode
            ? Colors.white54
            : Colors.grey[600]!;

    final Color iconColor =
        isDarkMode
            ? Colors.white60
            : Colors.grey[600]!;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.25)
                : Colors.grey.withOpacity(0.20),

            spreadRadius: 2,
            blurRadius: 8,

            offset:
                const Offset(0, 4),
          ),

          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.10)
                : Colors.grey.withOpacity(0.08),

            spreadRadius: 4,
            blurRadius: 20,

            offset:
                const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ============================================
          // ENCABEZADO
          // ============================================

          Row(
            children: [
              CircleAvatar(
                radius: 16,

                backgroundColor:
                    isDarkMode
                        ? const Color(0xFF3A3A3A)
                        : Colors.grey[300],

                child: Icon(
                  Icons.person,
                  size: 18,
                  color: isDarkMode
                      ? Colors.white70
                      : Colors.grey,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      widget.post.autor,

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,

                        fontSize: 14,

                        color:
                            primaryTextColor,
                      ),
                    ),

                    Text(
                      widget.post.usuario,

                      style: TextStyle(
                        fontSize: 12,

                        color:
                            mutedTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                widget.post.tiempo,

                style: TextStyle(
                  fontSize: 12,

                  color: isDarkMode
                      ? Colors.white38
                      : Colors.grey[400],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.more_horiz,
                size: 20,

                color: isDarkMode
                    ? Colors.white54
                    : Colors.grey[400],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ============================================
          // CONTENIDO
          // ============================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      widget.post.titulo,

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,

                        fontSize: 16,

                        color:
                            primaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      widget.post.contenido,

                      style: TextStyle(
                        fontSize: 14,

                        color:
                            secondaryTextColor,
                      ),

                      maxLines: 3,

                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ========================================
              // IMAGEN
              // ========================================

              if (widget.post.imagen != null)
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8),

                  child: Image.asset(
                    widget.post.imagen!,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,

                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        width: 120,
                        height: 80,

                        decoration:
                            BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF333333)
                              : Colors.grey[200],

                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                        ),

                        child: Icon(
                          Icons
                              .image_not_supported,

                          size: 30,

                          color: isDarkMode
                              ? Colors.white54
                              : Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // ============================================
          // ACCIONES
          // ============================================

          Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,

                child: Row(
                  children: [
                    Icon(
                      isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,

                      size: 20,

                      color: isLiked
                          ? const Color(
                              0xFF931212,
                            )
                          : iconColor,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      '$likes',

                      style: TextStyle(
                        fontSize: 14,

                        color: isLiked
                            ? const Color(
                                0xFF931212,
                              )
                            : primaryTextColor,

                        fontWeight: isLiked
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 20,

                    color: iconColor,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '${widget.post.comentarios}',

                    style: TextStyle(
                      fontSize: 14,

                      color:
                          primaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}