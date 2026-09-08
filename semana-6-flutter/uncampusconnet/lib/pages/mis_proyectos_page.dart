import 'package:flutter/material.dart';

import 'package:uncampusconnet/widgets/header_banner.dart';
import 'package:uncampusconnet/widgets/quick_access_buttons.dart';
import 'package:uncampusconnet/widgets/development_dialog.dart';
import 'package:uncampusconnet/widgets/project_card.dart';
import 'package:uncampusconnet/widgets/project_data.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);
const Color darkRed = Color(0xFF941818);
const Color backgroundColor = Color(0xFFF5F5F5);

// ======================================================
// PÁGINA MIS PROYECTOS
// ======================================================

class MisProyectosPage extends StatelessWidget {
  const MisProyectosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
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
                            child: const Icon(
                              Icons.chevron_left,
                              size: 28,
                              color: Colors.black87,
                            ),
                          ),

                          const Expanded(
                            child: Center(
                              child: Text(
                                'Mis proyectos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 28),
                        ],
                      ),
                    ),

                    const Divider(
                      height: 1,
                      color: Color(0xFFD9D9D9),
                    ),

                    const SizedBox(height: 22),

                    // ======================================
                    // BUSCADOR
                    // ======================================

                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9C9C9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Buscar por categoría',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          suffixIcon: Icon(
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
                          separatorBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return const SizedBox(height: 28);
                          },
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            final project = projects[index];

                            return ProjectCard(
                              title: project.title,
                              members: project.members,
                              role: project.role,
                              progress: project.progress,

                              onTap: () {
                                showDevelopmentDialog(context);
                              },

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

              onInicioTap: () {
                Navigator.pop(context);
              },

              onMisProyectosTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}