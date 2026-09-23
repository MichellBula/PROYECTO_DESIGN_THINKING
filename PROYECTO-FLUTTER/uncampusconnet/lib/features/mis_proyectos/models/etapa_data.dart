class AvanceData {
  final String autor;
  final String etiqueta;
  final String descripcion;
  final DateTime fecha;
  final List<String> archivos;

  const AvanceData({
    required this.autor,
    required this.etiqueta,
    required this.descripcion,
    required this.fecha,
    this.archivos = const [],
  });

  AvanceData copyWith({
    String? autor,
    String? etiqueta,
    String? descripcion,
    DateTime? fecha,
    List<String>? archivos,
  }) {
    return AvanceData(
      autor: autor ?? this.autor,
      etiqueta: etiqueta ?? this.etiqueta,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      archivos: archivos ?? this.archivos,
    );
  }
}

class EtapaData {
  final String etiqueta;
  final String descripcion;
  final double progreso;
  final DateTime fechaFin;
  final List<AvanceData> avances;

  const EtapaData({
    required this.etiqueta,
    required this.descripcion,
    required this.progreso,
    required this.fechaFin,
    this.avances = const [],
  });

  EtapaData copyWith({
    String? etiqueta,
    String? descripcion,
    double? progreso,
    DateTime? fechaFin,
    List<AvanceData>? avances,
  }) {
    return EtapaData(
      etiqueta: etiqueta ?? this.etiqueta,
      descripcion: descripcion ?? this.descripcion,
      progreso: progreso ?? this.progreso,
      fechaFin: fechaFin ?? this.fechaFin,
      avances: avances ?? this.avances,
    );
  }
}