import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // Variable que guarda la cantidad de likes que tiene el post
  late int likes;
  
  // Variable que guarda si el usuario ya dio like o no
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    // Al iniciar, tomamos los datos del post que nos llegaron
    likes = widget.post['likes'] ?? 0;
    isLiked = widget.post['isLiked'] ?? false;
  }

  // Esta funcion se ejecuta cuando el usuario toca el corazon
  void _toggleLike() {
    setState(() {
      // Si el usuario ya habia dado like, lo quitamos
      if (isLiked) {
        likes--;
        isLiked = false;
      } else {
        // Si no habia dado like, lo agregamos
        likes++;
        isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Separacion entre cada tarjeta de publicacion
      margin: const EdgeInsets.symmetric(vertical: 8),
      // Espacio interno dentro de la tarjeta
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Fondo blanco para la tarjeta
        color: Colors.white,
        // Esquinas redondeadas
        borderRadius: BorderRadius.circular(12),
        // Sombra para dar efecto de elevacion y flotante
        boxShadow: [
          // Sombra principal para efecto flotante
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          // Sombra secundaria para efecto mas difuso
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 4,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        // Todo el contenido alineado a la izquierda
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila del encabezado: avatar, autor, usuario, tiempo y menu
          Row(
            children: [
              // Circulo del avatar del usuario
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 10),
              // Columna con el nombre del autor y su usuario
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post['autor'] ?? 'Usuario',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.post['usuario'] ?? '@usuario',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              // Empuja el contenido a la derecha
              const Spacer(),
              // Texto que indica hace cuanto se publico
              Text(
                widget.post['tiempo'] ?? 'Hace 2h',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 8),
              // Icono de los tres puntos para mas opciones
              Icon(
                Icons.more_horiz,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Fila que contiene el texto del post y la imagen
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda: titulo y descripcion
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titulo de la publicacion
                    Text(
                      widget.post['titulo'] ?? 'Título de la publicación',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Contenido o descripcion de la publicacion
                    Text(
                      widget.post['contenido'] ?? 'Contenido de la publicación...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Columna derecha: imagen adjunta si existe
              if (widget.post['imagen'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.post['imagen'],
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Si la imagen no se puede cargar, mostramos un placeholder
                      return Container(
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Fila de acciones: like y comentarios
          Row(
            children: [
              // Boton de like con su contador
              GestureDetector(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    // Cambia entre corazon lleno o vacio segun si tiene like
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: isLiked ? const Color(0xFF500000) : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    // Numero de likes
                    Text(
                      '$likes',
                      style: TextStyle(
                        fontSize: 14,
                        color: isLiked ? const Color(0xFF500000) : Colors.black,
                        fontWeight: isLiked ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Icono y contador de comentarios
              Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.post['comentarios'] ?? 0}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
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