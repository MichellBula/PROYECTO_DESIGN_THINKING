import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';
import 'package:uncampusconnet/ui/widgets/project_card.dart';

const primaryRed = Color(0xFF931212);
const darkRed = Color(0xFF941818);

class MisProyectosPage extends StatelessWidget {
  const MisProyectosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background =
        isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

    final textColor =
        isDark ? Colors.white : Colors.black87;

    final dividerColor =
        isDark ? const Color(0xFF333333) : const Color(0xFFD9D9D9);

    final searchColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFC9C9C9);

    final hintColor =
        isDark ? Colors.white60 : Colors.white;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // TÍTULO Y BOTÓN VOLVER
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.find<MainController>().currentIndex.value = 0;
                      },
                      child: Icon(
                        Icons.chevron_left,
                        size: 28,
                        color: textColor,
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: Text(
                          'Mis proyectos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 28),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color: dividerColor,
              ),

              const SizedBox(height: 22),

              // BUSCADOR
              Container(
                height: 38,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: searchColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar por categoría',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: hintColor,
                    ),
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

              // LISTA DE PROYECTOS
              Expanded(
                child: ListView.separated(
                  itemCount: projects.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 28),
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    return ProjectCard(
                      title: project.title,
                      members: project.members,
                      role: project.role,
                      progress: project.progress,

                      // Tarjeta completa
                      onTap: () => showDevelopmentDialog(context),

                      // Tres puntos
                      onMenuTap: () => showDevelopmentDialog(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}