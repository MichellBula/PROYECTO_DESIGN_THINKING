import 'package:flutter/material.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/theme/theme.dart';
import '../domain/entities/profile.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final String initials;
  final VoidCallback? onLogout;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.initials,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Stack(
        children: [
          // AVATAR + INFO
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: scheme.onPrimary,
                child: Text(
                  initials,
                  style: AppTextStyles.greeting.copyWith(
                    color: scheme.primary,
                  ),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${profile.nombreUsuario}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.greeting.copyWith(
                        color: scheme.onPrimary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    if (profile.carrera.isNotEmpty)
                      Text(
                        'Estudiante de ${profile.carrera}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.smallText.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),

                    if (profile.semestre.isNotEmpty)
                      Text(
                        '${profile.semestre} semestre',
                        style: AppTextStyles.smallText.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),

                    Text(
                      'Universidad del Norte',
                      style: AppTextStyles.smallText.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // BOTON CERRAR SESION (esquina superior derecha)
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: onLogout,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.logout,
                  size: 22,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}