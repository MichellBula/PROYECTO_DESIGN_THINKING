import 'package:flutter/material.dart';

const Color primaryRed = Color(0xFF931212);

class ProjectCard extends StatelessWidget {
  final String title;
  final String members;
  final String role;
  final double progress;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const ProjectCard({
    super.key,
    required this.title,
    required this.members,
    required this.role,
    required this.progress,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final int percentage = (progress * 100).round();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 94,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ==========================================
              // CÍRCULO DEL PROYECTO
              // ==========================================

              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF720000),
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 10),

              // ==========================================
              // INFORMACIÓN
              // ==========================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      'Integrantes: $members',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),

                    Text(
                      'Rol: $role',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // ======================================
                    // PROGRESO
                    // ======================================

                    Row(
                      children: [
                        const Text(
                          'Progreso:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor:
                                  const Color(0xFFD4D4D4),
                              valueColor:
                                  const AlwaysStoppedAnimation<
                                      Color>(
                                primaryRed,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ==========================================
              // MENÚ DE TRES PUNTOS
              // ==========================================

              GestureDetector(
                onTap: onMenuTap,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.more_vert,
                      size: 22,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}