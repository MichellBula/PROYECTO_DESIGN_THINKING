import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';

/// Tarjeta utilizada para mostrar un proyecto dentro
/// de la lista de "Mis proyectos".
///
/// Toda la tarjeta es pulsable mediante [onTap].
class ProjectCard extends StatelessWidget {
  /// Nombre del proyecto.
  final String title;

  /// Número de integrantes.
  final String members;

  /// Rol del usuario.
  final String role;

  /// Progreso entre 0.0 y 1.0.
  final double progress;

  /// Acción ejecutada al tocar la tarjeta.
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.title,
    required this.members,
    required this.role,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final int percentage = (progress * 100).round();

    return CardWrapper(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: SizedBox(
        height: 94,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // ==========================================
              // IMAGEN / CÍRCULO
              // ==========================================

              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: scheme.primary,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),

                    Text(
                      'Integrantes: $members',
                      style: AppTextStyles.smallText.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),

                    Text(
                      'Rol: $role',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.smallText.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // ======================================
                    // PROGRESO
                    // ======================================
                    Row(
                      children: [
                        Text(
                          'Progreso:',
                          style: AppTextStyles.smallText.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppTheme.smallRadius,
                            ),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor: scheme.outlineVariant,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                scheme.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Text(
                          '$percentage%',
                          style: AppTextStyles.smallText.copyWith(
                            color: scheme.onSurface,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
