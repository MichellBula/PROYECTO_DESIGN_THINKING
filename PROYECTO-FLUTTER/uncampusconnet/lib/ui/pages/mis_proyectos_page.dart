import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/header_banner.dart';
import 'package:uncampusconnet/ui/widgets/quick_access_buttons.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';
import 'package:uncampusconnet/ui/widgets/project_card.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);
const Color darkRed = Color(0xFF941818);

// ======================================================
// PÁGINA MIS PROYECTOS
// ======================================================

class MisProyectosPage extends StatelessWidget {
  const MisProyectosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color pageBackground = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5);

    final Color primaryTextColor = isDarkMode ? Colors.white : Colors.black87;

    final Color dividerColor = isDarkMode
        ? const Color(0xFF333333)
        : const Color(0xFFD9D9D9);

    final Color searchBackground = isDarkMode
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFC9C9C9);

    final Color hintColor = isDarkMode ? Colors.white60 : Colors.white;

    return Scaffold(
      backgroundColor: pageBackground,

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // HEADER
            // ==========================================

            const HeaderBanner(),

            // ==========================================
            // CONTENIDO
            // ==========================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // ======================================
                    // TÍTULO
                    // ======================================

                    SizedBox(
                      height: 52,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.chevron_left,
                              size: 28,
                              color: primaryTextColor,
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                'Mis proyectos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                          ),

                          // Espacio para mantener
                          // el título centrado
                          const SizedBox(width: 28),
                        ],
                      ),
                    ),

                    Divider(height: 1, color: dividerColor),

                    const SizedBox(height: 22),

                    // ======================================
                    // BUSCADOR
                    // ======================================
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: searchBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 12, color: primaryTextColor),
                        decoration: InputDecoration(
                          hintText: 'Buscar por categoría',
                          hintStyle: TextStyle(fontSize: 12, color: hintColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            size: 20,
                            color: darkRed,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ======================================
                    // LISTA DE PROYECTOS
                    // ======================================
                    Expanded(
                      child: ListView.separated(
                        itemCount: projects.length,

                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 28);
                        },

                        itemBuilder: (BuildContext context, int index) {
                          final ProjectData project = projects[index];

                          return ProjectCard(
                            title: project.title,
                            members: project.members,
                            role: project.role,
                            progress: project.progress,

                            // Pulsar la tarjeta completa
                            onTap: () {
                              showDevelopmentDialog(context);
                            },

                            // Pulsar los tres puntos
                            onMenuTap: () {
                              showDevelopmentDialog(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // BARRA INFERIOR
            // ==========================================
            QuickAccessButtons(
              selectedItem: QuickAccessItem.misProyectos,

              // Volver a Home
              onInicioTap: () {
                Navigator.pop(context);
              },

              // Ya estamos en esta pantalla
              onMisProyectosTap: () {},
              // Buscar
              onBuscarTap: () {
                Navigator.pop(context);
              },
              onSolicitudesTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
