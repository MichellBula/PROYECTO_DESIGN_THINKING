class CreateProjectRequest {
  final String nombreProyecto;
  final String descripcion;
  final String objetivo;

  final String categoria;
  final String? tipoProyecto;

  final List<String> roles;
  final Map<String, int> cantidadesPorRol;

  final List<String> habilidades;
  final String requisitos;

  final DateTime fechaInicio;
  final DateTime fechaCierre;

  final bool deseaDocente;

  const CreateProjectRequest({
    required this.nombreProyecto,
    required this.descripcion,
    required this.objetivo,
    required this.categoria,
    required this.tipoProyecto,
    required this.roles,
    required this.cantidadesPorRol,
    required this.habilidades,
    required this.requisitos,
    required this.fechaInicio,
    required this.fechaCierre,
    required this.deseaDocente,
  });
}
