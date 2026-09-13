import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/event_card.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';
import 'package:uncampusconnet/ui/widgets/home_data.dart';
import 'package:uncampusconnet/ui/widgets/event_data.dart';

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

  @override
  Widget build(BuildContext context) {
    // Detectar modo oscuro
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          30,
          15,
          30,
          20,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==========================================
            // SALUDO
            // ==========================================

            Text(
              'Hola, Juan!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              '¿Qué deseas hacer hoy?',
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),

            const SizedBox(height: 18),

            // ==========================================
            // TITULO + VER TODOS
            // ==========================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Eventos próximos:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black,
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
            // CARRUSEL DINÁMICO
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

                  // Movimiento horizontal
                  scrollDirection: Axis.horizontal,

                  // La cantidad de tarjetas depende
                  // del tamaño de la lista "events".
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
                    // Obtener el evento actual
                    final EventData event =
                        events[index];

                    // Crear una tarjeta con ese evento
                    return EventCard(
                      event: event,
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
    );
  }
}