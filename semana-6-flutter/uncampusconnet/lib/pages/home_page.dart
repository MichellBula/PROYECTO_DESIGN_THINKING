import 'package:flutter/material.dart';

import 'package:uncampusconnet/widgets/home_background.dart';
import 'package:uncampusconnet/widgets/header_banner.dart';
import 'package:uncampusconnet/widgets/quick_access_buttons.dart';
import 'package:uncampusconnet/widgets/home_event.dart';
import 'package:uncampusconnet/widgets/post_list.dart';
import 'package:uncampusconnet/widgets/posts_data.dart';
import 'package:uncampusconnet/pages/mis_proyectos_page.dart';

// Pantalla principal de la aplicacion
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // Los widgets se apilan uno encima del otro
        children: [
          // Fondo de la pantalla
          const HomeBackground(),

          // Banner fijo en la parte superior con el logo y el nombre
          const HeaderBanner(),

          // Contenido principal que va entre el banner y los botones inferiores
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 75,
            child: Column(
              children: [
                // Seccion de eventos
                const HomeEvents(),

                // Lista de publicaciones (scrolleable)
                Expanded(
                  child: PostList(
                    posts: Post.posts,
                  ),
                ),
              ],
            ),
          ),

          // Botones de acceso rapido fijos en la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: QuickAccessButtons(
              selectedItem: QuickAccessItem.inicio,

              onMisProyectosTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MisProyectosPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}