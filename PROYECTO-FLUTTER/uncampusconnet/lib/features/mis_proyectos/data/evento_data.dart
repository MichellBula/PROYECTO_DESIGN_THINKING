class EventoData {
  final int idEvento;
  final int idProyecto;
  final String nombre;
  final String tipoEvento;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinal;

  const EventoData({
    required this.idEvento,
    required this.idProyecto,
    required this.nombre,
    required this.tipoEvento,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFinal,
  });

  factory EventoData.fromMap(Map<String, dynamic> map) {
    return EventoData(
      idEvento: int.tryParse(map['id_evento'].toString()) ?? 0,
      idProyecto: int.tryParse(map['id_proyecto'].toString()) ?? 0,
      nombre: map['nombre']?.toString() ?? '',
      tipoEvento: map['tipo_evento']?.toString() ?? '',
      descripcion: map['descripcion']?.toString() ?? '',
      fechaInicio: DateTime.parse(map['fecha_inicio'].toString()),
      fechaFinal: DateTime.parse(map['fecha_final'].toString()),
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'id_evento': idEvento,
      'id_proyecto': idProyecto,
      'nombre': nombre,
      'tipo_evento': tipoEvento,
      'descripcion': descripcion,
      'fecha_inicio': fechaInicio.toIso8601String().split('.').first,
      'fecha_final': fechaFinal.toIso8601String().split('.').first,
    };
  }
}