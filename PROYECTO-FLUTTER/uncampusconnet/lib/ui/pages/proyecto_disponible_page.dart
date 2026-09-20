import 'package:flutter/material.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';

class ProyectoDisponiblePage extends StatelessWidget {
  final ProjectInfo project;

  const ProyectoDisponiblePage({
    super.key,
    required this.project,
  });

  static const wineColor = Color(0xFF6B0000);

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDarkMode
            ? const Color(0xFF121212)
            : const Color(0xFFF7F7F7);

    final textColor =
        isDarkMode
            ? Colors.white
            : const Color(0xFF0A0A0A);

    final cardColor =
        isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(textColor: textColor),

            const SizedBox(height: 14),

            _ProjectHeader(
              project: project,
              textColor: textColor,
            ),

            const SizedBox(height: 18),

            _SectionTitle(
              title: 'Descripción:',
              color: textColor,
            ),

            const SizedBox(height: 8),

            _InfoCard(
              color: cardColor,
              child: Text(
                project.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.3,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _SectionTitle(
              title: 'Requisitos:',
              color: textColor,
            ),

            const SizedBox(height: 8),

            _InfoCard(
              color: cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: project.requirements
                    .map(
                      (requirement) => Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
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
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 18),

            _SectionTitle(
              title: 'Roles disponibles:',
              color: textColor,
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.roles
                  .map(
                    (role) => Container(
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
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 18),

            _SectionTitle(
              title: 'Fecha cierre convocatoria:',
              color: textColor,
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
                      project.closingDate,
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
    );
  }
}

class _Header extends StatelessWidget {
  final Color textColor;

  const _Header({
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
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
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  final ProjectInfo project;
  final Color textColor;

  const _ProjectHeader({
    required this.project,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 95,
          height: 95,
          decoration: const BoxDecoration(
            color: ProyectoDisponiblePage.wineColor,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                '${project.members} integrantes',
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                ),
              ),

              Text(
                '${project.vacancies} vacantes',
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Líder: ${project.leader}',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),

              Text(
                project.area,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final Widget child;

  const _InfoCard({
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}