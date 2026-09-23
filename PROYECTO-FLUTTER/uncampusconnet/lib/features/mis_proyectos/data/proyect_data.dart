/// Modelo que representa un proyecto.
class ProjectData {
  //Identificacion
  /// ID del proyecto en Roble.
  final int idProyecto;

  //Informacion basica
  final String title;
  final String leader;
  final String description;
  final String requirements;
  final String category;

  //Integrantes
  final int membersCount;
  final int vacancies;
  final Map<String, int> vacancyRoles;

  //Fecha
  final DateTime? closingDate;

  //Tarjeta
  final double progress;

  const ProjectData({
    required this.idProyecto,
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

  String get members => membersCount.toString();

  String get role => '';
}