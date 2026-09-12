import 'package:flutter/material.dart';
import 'package:uncampusconnet/ui/widgets/home_background.dart';
import 'package:uncampusconnet/ui/widgets/header_banner.dart';
import 'package:uncampusconnet/ui/widgets/quick_access_buttons.dart';
import 'package:uncampusconnet/ui/widgets/home_event.dart';
import 'package:uncampusconnet/ui/widgets/post_list.dart';
import 'package:uncampusconnet/ui/pages/mis_proyectos_page.dart';
import 'package:uncampusconnet/ui/pages/solicitudes_page.dart';
import 'package:uncampusconnet/ui/pages/buscar_page.dart';

// Pantalla principal de la aplicacion
class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de la pantalla
          const HomeBackground(),

          // Banner fijo en la parte superior con el logo y el nombre
          const HeaderBanner(),

          // Botón para cambiar modo claro / oscuro
          Positioned(
            top: 20,
            right: 100,
            child: IconButton(
              onPressed: onThemeChanged,
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.amber : Colors.black87,
              ),
              tooltip: isDarkMode
                  ? 'Cambiar a modo claro'
                  : 'Cambiar a modo oscuro',
            ),
          ),

          // Contenido principal
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 75,
            child: Column(
              children: [
                const HomeEvents(),

                Expanded(child: PostList(posts: Post.posts)),
              ],
            ),
          ),

          // Botones inferiores
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: QuickAccessButtons(
              selectedItem: QuickAccessItem.inicio,

              onBuscarTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BuscarPage()),
                );
              },

              onMisProyectosTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MisProyectosPage(),
                  ),
                );
              },

              onSolicitudesTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SolicitudesPage(),
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
