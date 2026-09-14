import 'package:flutter/material.dart';
import 'package:uncampusconnet/ui/widgets/header_banner.dart';
import 'package:uncampusconnet/ui/widgets/quick_access_buttons.dart';

class ProyectoDisponiblePage extends StatelessWidget {
  final String leader;
  final String name;
  final String members;
  final String vacancies;
  final String closingDate;
  final String area;
  final String description;
  final List<String> requirements;
  final List<String> roles;

  const ProyectoDisponiblePage({
    super.key,
    required this.leader,
    required this.name,
    required this.members,
    required this.vacancies,
    required this.closingDate,
    required this.area,
    required this.description,
    required this.requirements,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F7F7);

    final Color textColor =
        isDarkMode ? Colors.white : const Color(0xFF0A0A0A);

    final Color cardColor =
        isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    const Color wineColor = Color(0xFF6B0000);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const HeaderBanner(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================================
                  // TÍTULO Y BOTÓN VOLVER
                  // ======================================================

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: textColor,
                        ),
                      ),

                      Expanded(
                        child: Text(
                          'Proyecto disponible',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 42),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ======================================================
                  // INFORMACIÓN PRINCIPAL
                  // ======================================================

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 95,
                        height: 95,
                        decoration: const BoxDecoration(
                          color: wineColor,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              '$members integrantes',
                              style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),

                            Text(
                              '$vacancies vacantes',
                              style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              'Líder: $leader',
                              style: TextStyle(
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),

                            Text(
                              area,
                              style: TextStyle(
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ======================================================
                  // DESCRIPCIÓN
                  // ======================================================

                  Text(
                    'Descripción:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        color: textColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ======================================================
                  // REQUISITOS
                  // ======================================================

                  Text(
                    'Requisitos:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: requirements.map(
                        (requirement) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '•',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: wineColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    requirement,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ======================================================
                  // ROLES DISPONIBLES
                  // ======================================================

                  Text(
                    'Roles disponibles:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: roles.map(
                      (role) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E2E2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            role,
                            style: const TextStyle(
                              color: wineColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),

                  const SizedBox(height: 18),

                  // ======================================================
                  // FECHA DE CIERRE
                  // ======================================================

                  Text(
                    'Fecha cierre convocatoria:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Container(
                      width: 210,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E2E2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 17,
                            color: Colors.black87,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            closingDate,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ======================================================
                  // BOTÓN POSTULARSE
                  // ======================================================

                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: wineColor,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Postularse',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),

          // ======================================================
          // NAVEGACIÓN INFERIOR
          // ======================================================

          QuickAccessButtons(
            selectedItem: QuickAccessItem.buscar,

            onInicioTap: () {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },

            onBuscarTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}