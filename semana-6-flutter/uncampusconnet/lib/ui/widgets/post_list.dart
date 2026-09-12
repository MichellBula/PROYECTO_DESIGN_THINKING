import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/home_data.dart';
import 'package:uncampusconnet/ui/widgets/post_card.dart';

// ======================================================
// LISTA DE PUBLICACIONES
// ======================================================

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color titleColor =
        isDarkMode ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==============================================
        // TÍTULO
        // ==============================================

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Text(
            'Publicaciones:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ==============================================
        // LISTA DINÁMICA
        // ==============================================

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),

            // La cantidad de tarjetas depende
            // de la cantidad de publicaciones.
            itemCount: posts.length,

            separatorBuilder: (
              BuildContext context,
              int index,
            ) {
              return const SizedBox(height: 18);
            },

            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              // Obtener la publicación actual.
              final Post post = posts[index];

              // Crear una tarjeta para esa publicación.
              return PostCard(
                post: post,
              );
            },
          ),
        ),
      ],
    );
  }
}