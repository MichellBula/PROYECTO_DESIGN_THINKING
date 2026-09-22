/// Modelo que representa un proyecto.
///
/// Contiene la información necesaria para mostrar tanto
/// la tarjeta de "Mis proyectos" como el detalle completo.
class ProjectData {
  // ======================================================
  // INFORMACIÓN BÁSICA
  // ======================================================

  final String title;
  final String leader;
  final String description;
  final String requirements;
  final String category;

  // ======================================================
  // INTEGRANTES Y VACANTES
  // ======================================================

  /// Cantidad total de integrantes actuales.
  final int membersCount;

  /// Cantidad de vacantes disponibles.
  final int vacancies;

  /// Roles que están disponibles como vacantes.
  ///
  /// Ejemplo:
  /// {
  ///   'Programador': 2,
  ///   'Diseñador': 1,
  /// }
  final Map<String, int> vacancyRoles;

  // ======================================================
  // FECHA
  // ======================================================

  final DateTime? closingDate;

  // ======================================================
  // TARJETA
  // ======================================================

  final double progress;

  const ProjectData({
    required this.title,
    required this.leader,
    required this.description,
    required this.requirements,
    required this.category,
    required this.membersCount,
    required this.vacancies,
    required this.vacancyRoles,
    required this.closingDate,
    required this.progress,
  });

  String get members => "";

  String get role => "";
}

final List<ProjectData> projects = [
  ProjectData(
    title: 'Processing Music',
    leader: '@JuanPerez',

    description: 'Simulador de ondas estacionarias donde expones diferentes instrumentos musicales.',

    requirements:
        '• Saber de física de ondas estacionarias\n'
        '• Programar en Java',

    category: 'GeoExpofisica',

    membersCount: 5,

    vacancies: 2,

    vacancyRoles: const {'Programador': 1, 'Especialista en ondas': 1},

    closingDate: DateTime(2026, 9, 2),

    progress: 0.10,
  ),

  ProjectData(
    title: 'MyDailyPet',
    leader: '@MariaGomez',

    description: 'Aplicación para ayudar a las personas a organizar el cuidado diario de sus mascotas.',

    requirements:
        '• Conocimientos básicos de diseño\n'
        '• Trabajo en equipo',

    category: 'grupo estudiantiles',

    membersCount: 3,

    vacancies: 2,

    vacancyRoles: const {'Diseñador UX/UI': 1, 'Desarrollador': 1},

    closingDate: DateTime(2026, 10, 15),

    progress: 0.90,
  ),
];
