import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int likes;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    likes = widget.post['likes'] ?? 0;
    isLiked = widget.post['isLiked'] ?? false;
  }

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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDarkMode ? const Color(0xFF242424) : Colors.white;

    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;

    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.grey[700];

    final mutedTextColor = isDarkMode ? Colors.white54 : Colors.grey[600];

    final iconColor = isDarkMode ? Colors.white60 : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: isDarkMode
                // ignore: deprecated_member_use
                ? Colors.black.withOpacity(0.25)
                // ignore: deprecated_member_use
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: isDarkMode
                // ignore: deprecated_member_use
                ? Colors.black.withOpacity(0.10)
                // ignore: deprecated_member_use
                : Colors.grey.withOpacity(0.08),
            spreadRadius: 4,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ENCABEZADO
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isDarkMode
                    ? const Color(0xFF3A3A3A)
                    : Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: isDarkMode ? Colors.white70 : Colors.grey,
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post['autor'] ?? 'Usuario',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: primaryTextColor,
                    ),
                  ),

                  Text(
                    widget.post['usuario'] ?? '@usuario',
                    style: TextStyle(fontSize: 12, color: mutedTextColor),
                  ),
                ],
              ),

              const Spacer(),

              Text(
                widget.post['tiempo'] ?? 'Hace 2h',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white38 : Colors.grey[400],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.more_horiz,
                size: 20,
                color: isDarkMode ? Colors.white54 : Colors.grey[400],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // CONTENIDO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post['titulo'] ?? 'Título de la publicación',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: primaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      widget.post['contenido'] ??
                          'Contenido de la publicación...',
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              if (widget.post['imagen'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.post['imagen'],
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 80,

                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF333333)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: isDarkMode ? Colors.white54 : Colors.grey,
                        ),
                      );
                    },
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
                      color: isLiked ? const Color(0xFF931212) : iconColor,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      '$likes',
                      style: TextStyle(
                        fontSize: 14,
                        color: isLiked
                            ? const Color(0xFF931212)
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
                  Icon(Icons.chat_bubble_outline, size: 20, color: iconColor),

                  const SizedBox(width: 4),

                  Text(
                    '${widget.post['comentarios'] ?? 0}',
                    style: TextStyle(fontSize: 14, color: primaryTextColor),
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
