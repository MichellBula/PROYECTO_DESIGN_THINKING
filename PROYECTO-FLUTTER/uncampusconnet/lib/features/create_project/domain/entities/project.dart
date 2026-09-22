class Project {
  final String nombre;
  final String descripcion;
  final int idCreador;
  final int idCategoria;
  final int idTipoProyecto;
  final String objetivo;
  final String requisitos;
  final int numIntegrantes;
  final bool docenteAsesor;
  final String estado;

  const Project({
    required this.nombre,
    required this.descripcion,
    required this.idCreador,
    required this.idCategoria,
    required this.idTipoProyecto,
    required this.objetivo,
    required this.requisitos,
    required this.numIntegrantes,
    required this.docenteAsesor,
    required this.estado,
  });
}