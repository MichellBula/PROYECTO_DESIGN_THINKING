import 'package:flutter/material.dart';

import 'event_data.dart';
import 'event_card.dart';
import 'development_dialog.dart';

// ======================================================
// SECCIÓN DE EVENTOS
// ======================================================

class HomeEvents extends StatefulWidget {
  const HomeEvents({super.key});

  @override
  State<HomeEvents> createState() => _HomeEventsState();
}

class _HomeEventsState extends State<HomeEvents> {
  final ScrollController _scrollController =
      ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ====================================================
  // BUILD
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            30,
            15,
            30,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // SALUDO
              // ==========================================

              const Text(
                'Hola, Juan!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                '¿Qué deseas hacer hoy?',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 18),

              // ==========================================
              // EVENTOS + VER TODOS
              // ==========================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Eventos próximos:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      showDevelopmentDialog(context);
                    },
                    child: const Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF931212),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ==========================================
              // CARRUSEL
              // ==========================================

              SizedBox(
                height: 125,
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  thickness: 5,
                  radius: const Radius.circular(10),
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: events.length,
                    separatorBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      return const SizedBox(width: 12);
                    },
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      return EventCard(
                        event: events[index],
                        onTap: () {
                          showDevelopmentDialog(context);
                        },
                      );
                    },
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

// ======================================================
// DATOS DE LOS EVENTOS
// ======================================================

const List<EventData> events = [
  EventData(
    day: 'Mañana',
    time: '10:00 am',
    title: 'Entrega avance',
    project: 'ElectroPesca',
    tag: 'Avance',
    icon: Icons.calendar_today_outlined,
    type: EventType.task,
  ),

  EventData(
    day: 'Jueves',
    time: '2:00 pm',
    title: 'Reunión equipo',
    project: 'ServiGo',
    tag: 'Reunión',
    icon: Icons.person_outline,
    type: EventType.meeting,
  ),

  EventData(
    day: 'Viernes',
    time: '11:00 am',
    title: 'Presentación',
    project: 'InnovaTech',
    tag: 'Presentación',
    icon: Icons.slideshow_outlined,
    type: EventType.task,
  ),

  EventData(
    day: 'Sábado',
    time: '3:00 pm',
    title: 'Revisión proyecto',
    project: 'Grupo Alfa',
    tag: 'Revisión',
    icon: Icons.folder_open_outlined,
    type: EventType.task,
  ),

  EventData(
    day: 'Lunes',
    time: '9:00 am',
    title: 'Reunión general',
    project: 'InnovaTech',
    tag: 'Reunión',
    icon: Icons.groups_outlined,
    type: EventType.meeting,
  ),
];