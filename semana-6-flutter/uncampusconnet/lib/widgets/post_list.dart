import 'package:flutter/material.dart';
import 'package:uncampusconnet/widgets/post_card.dart';
import 'package:uncampusconnet/widgets/posts_data.dart';

// Widget que muestra la lista completa de publicaciones
class PostList extends StatelessWidget {
  // Lista de posts que recibe desde la pantalla principal
  final List<Post> posts;

  const PostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Column(
      // Todo el contenido alineado a la izquierda
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Espacio superior para separar el titulo de los eventos
        const SizedBox(height: 20),
        
        // Titulo de la seccion de publicaciones
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Text(
            'Publicaciones:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        
        // Espacio entre el titulo y la primera publicacion
        const SizedBox(height: 12),
        
        // Lista scrolleable de publicaciones
        Expanded(
          child: ListView.separated(
            // Margen horizontal para que las tarjetas no toquen los bordes
            padding: const EdgeInsets.symmetric(horizontal: 30),
            // Cantidad de publicaciones a mostrar
            itemCount: posts.length,
            // Separacion entre cada publicacion
            separatorBuilder: (context, index) => const SizedBox(height: 18),
            // Construye cada tarjeta de publicacion
            itemBuilder: (context, index) {
              // Convierte cada Post a Map para que PostCard lo entienda
              return PostCard(post: posts[index].toMap());
            },
          ),
        ),
      ],
    );
  }
}