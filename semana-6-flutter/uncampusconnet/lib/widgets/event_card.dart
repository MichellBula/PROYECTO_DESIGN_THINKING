import 'package:flutter/material.dart';
import 'event_data.dart';

const Color cardBgColor = Color(0xFFE2DFDF);

// Colores para REUNIONES (Rojo/Granate oscuro)
const Color meetingIconBg = Color(0xFF6B0F0F);
const Color meetingTagBg = Color(0xFFD6BFC0);
const Color meetingTextColor = Color(0xFF6B0F0F);

// Colores para OTROS EVENTOS (Rojo más claro)
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
    final bool isMeeting = event.type == EventType.meeting;

    final Color iconBg = isMeeting ? meetingIconBg : otherIconBg;
    final Color tagBg = isMeeting ? meetingTagBg : otherTagBg;
    final Color primaryColor = isMeeting ? meetingTextColor : otherTextColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 130,
          padding: const EdgeInsets.all(8), // Reducido para evitar desbordamiento
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(14),
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
                      color: iconBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      event.icon,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: Colors.black54,
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
                  color: primaryColor,
                ),
              ),

              // TÍTULO
              Text(
                event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              // PROYECTO
              Text(
                event.project,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black45,
                ),
              ),

              const Spacer(), // Empuja el tag al final aprovechando el espacio restante

              // ETIQUETA / TAG
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  event.tag,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
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