import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/header_banner.dart';
import 'package:uncampusconnet/ui/widgets/quick_access_buttons.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);
const Color darkRed = Color(0xFF941818);

// ======================================================
// PÁGINA BUSCAR
// ======================================================

class BuscarPage extends StatelessWidget {
  const BuscarPage({super.key});

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

    // Datos de prueba
    final List<String> resultados = [
      'Diseño de aplicaciones móviles',
      'Inteligencia Artificial',
      'Desarrollo Web',
      'Bases de Datos',
      'Redes de Computadores',
    ];

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
                                'Buscar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                          ),

                          // Espacio para mantener centrado
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
                          hintText: 'Buscar',
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

                    const SizedBox(height: 30),

                    // ======================================
                    // RESULTADOS
                    // ======================================
                    Expanded(
                      child: ListView.separated(
                        itemCount: resultados.length,

                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(color: dividerColor, height: 1);
                        },

                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),

                            leading: CircleAvatar(
                              backgroundColor:
                                  // ignore: deprecated_member_use
                                  primaryRed.withOpacity(0.1),
                              child: const Icon(
                                Icons.search,
                                color: primaryRed,
                                size: 20,
                              ),
                            ),

                            title: Text(
                              resultados[index],
                              style: TextStyle(
                                fontSize: 13,
                                color: primaryTextColor,
                              ),
                            ),

                            trailing: Icon(
                              Icons.chevron_right,
                              color: primaryTextColor,
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
              selectedItem: QuickAccessItem.buscar,

              // Volver a Home
              onInicioTap: () {
                Navigator.pop(context);
              },

              // Ya estamos en Buscar
              onBuscarTap: () {},

              // Crear
              onCrearTap: () {},

              // Mis proyectos
              onMisProyectosTap: () {
                Navigator.pop(context);
              },

              // Solicitudes
              onSolicitudesTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
