import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../domain/entities/profile.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final String initials;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.initials,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final scheme =
        Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius:
            BorderRadius.circular(
          AppTheme.cardRadius,
        ),
      ),
      child: Row(
        children: [
          // =================================================
          // AVATAR
          // =================================================

          CircleAvatar(
            radius: 40,
            backgroundColor:
                scheme.onPrimary,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.w700,
                color:
                    scheme.primary,
              ),
            ),
          ),

          const SizedBox(width: 18),

          // =================================================
          // INFORMACIÓN
          // =================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  profile.nombreUsuario,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        scheme.onPrimary,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                if (profile.carrera
                    .isNotEmpty)
                  Text(
                    profile.carrera,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme
                          .onPrimary
                          .withValues(
                        alpha: 0.9,
                      ),
                      fontSize: 14,
                    ),
                  ),

                if (profile.semestre
                    .isNotEmpty)
                  Text(
                    profile.semestre,
                    style: TextStyle(
                      color: scheme
                          .onPrimary
                          .withValues(
                        alpha: 0.9,
                      ),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}