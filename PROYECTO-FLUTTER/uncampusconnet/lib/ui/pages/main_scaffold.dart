import 'package:flutter/material.dart';
import 'package:uncampusconnet/ui/widgets/header_banner.dart';
import 'package:uncampusconnet/ui/pages/home_page.dart';
import 'package:uncampusconnet/ui/pages/buscar_page.dart';
import 'package:uncampusconnet/ui/pages/mis_proyectos_page.dart';
import 'package:uncampusconnet/ui/pages/solicitudes_page.dart';
import 'package:uncampusconnet/ui/pages/nuevo_proyecto.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);

// ======================================================
// CONTENEDOR PRINCIPAL
// ======================================================

class MainScaffold extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const MainScaffold({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  // Clave para controlar el Navigator interno
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  // Índice de la página actual
  int _currentIndex = 0;

  // Páginas del IndexedStack
  late final List<Widget> _pages = const [
    HomePage(),
    BuscarPage(),
    MisProyectosPage(),
    SolicitudesPage(),
  ];

  // Cambiar de pestaña desde el BottomNavigationBar
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Si hay pantallas push abiertas, las cierra
    _navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  // Abrir Nuevo Proyecto DENTRO del Navigator interno
  void _onCrearTap() {
    _navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => const NuevoProyectoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ==========================================
      // HEADER FIJO
      // ==========================================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderBanner(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),

      // ==========================================
      // CONTENIDO CON NAVIGATOR INTERNO + BARRA
      // ==========================================
      body: Column(
        children: [
          // CONTENIDO CON NAVIGATOR INTERNO
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) {
                    return IndexedStack(
                      index: _currentIndex,
                      children: _pages,
                    );
                  },
                );
              },
            ),
          ),

          // BARRA INFERIOR FIJA
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFFFAFAFA),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // INICIO
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.home_outlined,
                    label: 'Inicio',
                    index: 0,
                    isDark: isDark,
                  ),
                ),

                // BUSCAR
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.search,
                    label: 'Buscar',
                    index: 1,
                    isDark: isDark,
                  ),
                ),

                // CREAR
                Expanded(
                  child: _buildCreateButton(),
                ),

                // MIS PROYECTOS
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.groups_outlined,
                    label: 'Mis proyectos',
                    index: 2,
                    isDark: isDark,
                  ),
                ),

                // SOLICITUDES
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Solicitudes',
                    index: 3,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // ITEM DE NAVEGACIÓN
  // ======================================================
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final bool isSelected = _currentIndex == index;

    final Color color = isSelected
        ? primaryRed
        : (isDark ? Colors.white : Colors.black);

    return GestureDetector(
      onTap: () => _onTabChanged(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ======================================================
  // BOTÓN CREAR (como estaba antes)
  // ======================================================
  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: _onCrearTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: primaryRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Crear',
            style: TextStyle(fontSize: 11, color: primaryRed),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}