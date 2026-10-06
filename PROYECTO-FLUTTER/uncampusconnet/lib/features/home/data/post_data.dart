class PostData {
  final int idPublicacion;
  final int idProyecto;
  final String nombreProyecto;
  final String titulo;
  final String contenido;
  final DateTime fechaPublicacion;
  final int likes;
  final int comentarios;

  const PostData({
    required this.idPublicacion,
    required this.idProyecto,
    required this.nombreProyecto,
    required this.titulo,
    required this.contenido,
    required this.fechaPublicacion,
    required this.likes,
    required this.comentarios,
  });
}