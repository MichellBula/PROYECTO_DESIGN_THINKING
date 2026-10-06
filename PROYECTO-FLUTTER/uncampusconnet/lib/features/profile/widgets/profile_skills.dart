import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/profile/domain/entities/profile.dart';
import 'package:uncampusconnet/ui/widgets/cards_wrapper.dart';

class ProfileSkills extends StatelessWidget {
  final Profile profile;

  const ProfileSkills({
    super.key,
    required this.profile,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final scheme =
        Theme.of(context).colorScheme;

    return CardWrapper(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Mis habilidades',
            style:
                AppTextStyles.sectionTitle
                    .copyWith(
              color: scheme.onSurface,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          if (profile.habilidades
              .isEmpty)
            Text(
              'Todavía no tienes habilidades registradas.',
              style:
                  AppTextStyles.bodyText
                      .copyWith(
                color:
                    scheme.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  profile.habilidades
                      .map(
                (habilidad) {
                  return Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration:
                        BoxDecoration(
                      color: scheme.primary
                          .withValues(
                        alpha: 0.10,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        25,
                      ),
                      border:
                          Border.all(
                        color: scheme
                            .primary
                            .withValues(
                          alpha: 0.20,
                        ),
                      ),
                    ),
                    child: Text(
                      habilidad,
                      style: AppTextStyles
                          .smallText
                          .copyWith(
                        color:
                            scheme.primary,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
        ],
      ),
    );
  }
}