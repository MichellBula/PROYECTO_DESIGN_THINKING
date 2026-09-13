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

    final Color wineColor = const Color(0xFF6B0000);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const HeaderBanner(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO Y VOLVER
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 22,
                          color: textColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Proyecto disponible',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // INFORMACIÓN PRINCIPAL
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: wineColor,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 28),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              '$members integrantes',
                              style: TextStyle(
                                fontSize: 20,
                                color: textColor,
                              ),
                            ),

                            Text(
                              '$vacancies vacantes',
                              style: TextStyle(
                                fontSize: 20,
                                color: textColor,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Líder: $leader',
                              style: TextStyle(
                                fontSize: 19,
                                color: textColor,
                              ),
                            ),

                            Text(
                              area,
                              style: TextStyle(
                                fontSize: 19,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // DESCRIPCIÓN
                  Text(
                    'Descripción:',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.35,
                        color: textColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // REQUISITOS
                  Text(
                    'Requisitos:',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: requirements
                          .map(
                            (requirement) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                              ),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '•',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      requirement,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ROLES
                  Text(
                    'Roles disponibles:',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: roles.map(
                      (role) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E2E2),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              color: wineColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),

                  const SizedBox(height: 30),

                  // FECHA
                  Text(
                    'Fecha cierre convocatoria:',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Container(
                      width: 310,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E2E2),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        closingDate,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BOTÓN POSTULARSE
                  Center(
                    child: SizedBox(
                      width: 220,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: wineColor,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Postularse',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

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
