import 'package:flutter/material.dart';
import 'package:uncampusconnet/ui/widgets/home_background.dart';
import 'package:uncampusconnet/ui/widgets/home_event.dart';
import 'package:uncampusconnet/ui/widgets/post_list.dart';

// ======================================================
// PÁGINA PRINCIPAL (CONTENIDO DEL MEDIO)
// ======================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ==========================================
        // FONDO
        // ==========================================
        const HomeBackground(),

        // ==========================================
        // CONTENIDO
        // ==========================================
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,

          child: Column(
            children: [
              // Eventos
              const HomeEvents(),

              // Publicaciones
              const Expanded(child: PostList()),
            ],
          ),
        ),
      ],
    );
  }
}