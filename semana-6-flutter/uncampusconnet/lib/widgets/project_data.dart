class ProjectData {
  final String title;
  final String members;
  final String role;
  final double progress;

  const ProjectData({
    required this.title,
    required this.members,
    required this.role,
    required this.progress,
  });
}

const List<ProjectData> projects = [
  ProjectData(
    title: 'Processing Music',
    members: '5',
    role: 'Líder',
    progress: 0.10,
  ),
  ProjectData(
    title: 'MyDailyPet',
    members: '3',
    role: 'Diseñador de UI',
    progress: 0.90,
  ),
];