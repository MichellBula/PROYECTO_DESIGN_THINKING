import 'package:flutter/material.dart';
import 'event_data.dart';

// Colores para REUNIONES
const Color meetingIconBg = Color(0xFF6B0F0F);
const Color meetingTagBg = Color(0xFFD6BFC0);
const Color meetingTextColor = Color(0xFF6B0F0F);

// Colores para OTROS EVENTOS
const Color otherIconBg = Color(0xFF931212);
const Color otherTagBg = Color(0xFFE8C8C8);
const Color otherTextColor = Color(0xFF931212);

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
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final bool isMeeting =
        event.type == EventType.meeting;

    final Color iconBg =
        isMeeting ? meetingIconBg : otherIconBg;

    final Color primaryColor =
        isMeeting ? meetingTextColor : otherTextColor;

    final Color cardBgColor = isDarkMode
        ? const Color(0xFF242424)
        : const Color(0xFFE2DFDF);

    final Color titleColor = isDarkMode
        ? Colors.white
        : Colors.black87;

    final Color subtitleColor = isDarkMode
        ? Colors.white60
        : Colors.black45;

    final Color menuColor = isDarkMode
        ? Colors.white70
        : Colors.black54;

    final Color tagBg = isDarkMode
        ? (isMeeting
            ? const Color(0xFF4A2424)
            : const Color(0xFF522525))
        : (isMeeting ? meetingTagBg : otherTagBg);

    final Color dateColor = isDarkMode
        ? const Color(0xFFFFA0A0)
        : primaryColor;

    final Color tagTextColor = isDarkMode
        ? const Color(0xFFFFC2C2)
        : primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),

        child: Container(
          width: 130,
          padding: const EdgeInsets.all(8),

          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(14),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ICONO Y MENÚ
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius:
                          BorderRadius.circular(6),
                    ),
                    child: Icon(
                      event.icon,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),

                  GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: menuColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // FECHA Y HORA
              Text(
                '${event.day} - ${event.time}',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: dateColor,
                ),
              ),

              // TÍTULO
              Text(
                event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              // PROYECTO
              Text(
                event.project,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  color: subtitleColor,
                ),
              ),

              const Spacer(),

              // ETIQUETA / TAG
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  event.tag,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: tagTextColor,
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