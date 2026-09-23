class ProjectInfo {
  final int? idProyecto;
  final String leader;
  final String name;
  final String members;
  final String vacancies;
  final String closingDate;
  final String area;
  final String description;
  final List<String> requirements;
  final List<String> roles;
  final String keywords;

  const ProjectInfo({
    this.idProyecto,
    required this.leader,
    required this.name,
    required this.members,
    required this.vacancies,
    required this.closingDate,
    required this.area,
    required this.description,
    required this.requirements,
    required this.roles,
    required this.keywords,
  });
}
