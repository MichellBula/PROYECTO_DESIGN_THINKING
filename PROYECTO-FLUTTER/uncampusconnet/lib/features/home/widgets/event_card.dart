import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/home/data/event_data.dart';

class EventCard extends StatelessWidget {
  final EventData event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bool isMeeting = event.type == EventType.meeting;

    // Color principal según el tipo de evento
    final Color primaryColor = isMeeting
        ? AppTheme.meetingRed
        : scheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.eventCardRadius),
        child: Container(
          width: 130,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppTheme.eventCardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICONO Y MENÚ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(AppTheme.iconRadius),
                    ),
                    child: Icon(
                      event.icon,
                      size: 14,
                      color: scheme.onPrimary,
                    ),
                  ),
                  Icon(
                    Icons.more_horiz,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 4),

              //Fecha y hora
              Text(
                '${event.day} - ${event.time}',
                style: AppTextStyles.eventDate.copyWith(
                  color: primaryColor,
                ),
              ),

              //Título
              Text(
                event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.eventTitle.copyWith(
                  color: scheme.onSurface,
                ),
              ),

              // PROYECTO
              Text(
                event.project,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.eventProject.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),

              const Spacer(),

              //Etiqueta
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                ),
                child: Text(
                  event.tag,
                  style: AppTextStyles.eventTag.copyWith(
                    color: primaryColor,
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