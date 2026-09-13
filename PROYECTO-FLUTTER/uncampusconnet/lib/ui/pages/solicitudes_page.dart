import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/header_banner.dart';
import 'package:uncampusconnet/ui/widgets/quick_access_buttons.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);
const Color darkRed = Color(0xFF941818);

// ======================================================
// PÁGINA SOLICITUDES
// ======================================================

class SolicitudesPage extends StatefulWidget {
  const SolicitudesPage({super.key});

  @override
  State<SolicitudesPage> createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  // 0 = Recibidas
  // 1 = Enviadas
  int selectedTab = 0;

  // ======================================================
  // DATOS DE PRUEBA
  // ======================================================

  final List<String> solicitudesRecibidas = [
    'Carlos Pérez',
    'Laura Gómez',
    'Andrés Rodríguez',
    'María Fernández',
  ];

  final List<String> solicitudesEnviadas = [
    'Sebastián Torres',
    'Paula Martínez',
    'Daniel Hernández',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color pageBackground = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5);

    final Color primaryTextColor = isDarkMode ? Colors.white : Colors.black87;

    final Color dividerColor = isDarkMode
        ? const Color(0xFF333333)
        : const Color(0xFFD9D9D9);

    final Color searchBackground = isDarkMode
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFC9C9C9);

    final Color hintColor = isDarkMode ? Colors.white60 : Colors.white;

    // Elegimos qué lista mostrar
    final List<String> solicitudes = selectedTab == 0
        ? solicitudesRecibidas
        : solicitudesEnviadas;

    return Scaffold(
      backgroundColor: pageBackground,

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // HEADER
            // ==========================================

            const HeaderBanner(),

            // ==========================================
            // CONTENIDO
            // ==========================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // ======================================
                    // TÍTULO
                    // ======================================

                    SizedBox(
                      height: 52,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.chevron_left,
                              size: 28,
                              color: primaryTextColor,
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                'Solicitudes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 28),
                        ],
                      ),
                    ),

                    Divider(height: 1, color: dividerColor),

                    const SizedBox(height: 22),

                    // ======================================
                    // BARRA DE BÚSQUEDA
                    // ======================================
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: searchBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 12, color: primaryTextColor),
                        decoration: InputDecoration(
                          hintText: 'Buscar solicitudes',
                          hintStyle: TextStyle(fontSize: 12, color: hintColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            size: 20,
                            color: darkRed,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ======================================
                    // BOTONES RECIBIDAS / ENVIADAS
                    // ======================================
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 0;
                              });
                            },
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? primaryRed
                                    : Colors.transparent,

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(color: primaryRed),
                              ),
                              child: Center(
                                child: Text(
                                  'Recibidas',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: selectedTab == 0
                                        ? Colors.white
                                        : primaryRed,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 1;
                              });
                            },
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? primaryRed
                                    : Colors.transparent,

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(color: primaryRed),
                              ),
                              child: Center(
                                child: Text(
                                  'Enviadas',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: selectedTab == 1
                                        ? Colors.white
                                        : primaryRed,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // ======================================
                    // LISTA DE SOLICITUDES
                    // ======================================
                    Expanded(
                      child: solicitudes.isEmpty
                          ? Center(
                              child: Text(
                                'No hay solicitudes',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: solicitudes.length,

                              separatorBuilder:
                                  (BuildContext context, int index) {
                                    return Divider(
                                      color: dividerColor,
                                      height: 1,
                                    );
                                  },

                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 6,
                                  ),

                                  leading: CircleAvatar(
                                    // ignore: deprecated_member_use
                                    backgroundColor: primaryRed.withOpacity(
                                      0.1,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: primaryRed,
                                    ),
                                  ),

                                  title: Text(
                                    solicitudes[index],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: primaryTextColor,
                                    ),
                                  ),

                                  subtitle: Text(
                                    selectedTab == 0
                                        ? 'Te ha enviado una solicitud'
                                        : 'Solicitud enviada',
                                    style: TextStyle(
                                      fontSize: 11,
                                      // ignore: deprecated_member_use
                                      color: primaryTextColor.withOpacity(0.6),
                                    ),
                                  ),

                                  trailing: selectedTab == 0
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const Icon(
                                          Icons.schedule_outlined,
                                          color: Colors.grey,
                                        ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // BARRA INFERIOR
            // ==========================================
            QuickAccessButtons(
              selectedItem: QuickAccessItem.solicitudes,

              // Volver a Home
              onInicioTap: () {
                Navigator.pop(context);
              },

              // Buscar
              onBuscarTap: () {
                Navigator.pop(context);
              },

              // Crear
              onCrearTap: () {},

              // Mis proyectos
              onMisProyectosTap: () {
                Navigator.pop(context);
              },

              // Ya estamos en solicitudes
              onSolicitudesTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
