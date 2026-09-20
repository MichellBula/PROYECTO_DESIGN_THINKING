/// Contiene toda la información introducida en la segunda
/// pantalla del proceso de creación de un proyecto.
///
/// Este modelo permite transportar los datos de una pantalla
/// a otra sin tener que enviar cada variable por separado.
class ProjectDetailsData {
  final String objetivo;
  final List<String> roles;
  final Map<String, int> cantidadesPorRol;
  final List<String> habilidades;
  final String requisitos;
  final String? tipoProyecto;
  final DateTime? fechaInicio;
  final DateTime? fechaCierre;
  final bool deseaDocente;

  const ProjectDetailsData({
    required this.objetivo,
    required this.roles,
    required this.cantidadesPorRol,
    required this.habilidades,
    required this.requisitos,
    required this.tipoProyecto,
    required this.fechaInicio,
    required this.fechaCierre,
    required this.deseaDocente,
  });
}
