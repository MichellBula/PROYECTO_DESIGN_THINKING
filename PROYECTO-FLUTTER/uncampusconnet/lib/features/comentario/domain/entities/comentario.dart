class Comentario {
  final int idPublicacion;
  final int idUsuario;
  final String contenido;
  final DateTime fechaComentario;

  const Comentario({
    required this.idPublicacion,
    required this.idUsuario,
    required this.contenido,
    required this.fechaComentario,
  });
}