class Publicacion {
  final int idProyecto;
  final String titulo;
  final String contenido;
  final DateTime fechaPublicacion;

  const Publicacion({
    required this.idProyecto,
    required this.titulo,
    required this.contenido,
    required this.fechaPublicacion,
  });
}