import '../domain/entities/avance.dart';

class AvanceModel extends Avance {
  const AvanceModel({
    required super.idEtapa,
    required super.comentario,
    required super.fecha,
  });

  factory AvanceModel.fromEntity(
    Avance avance,
  ) {
    return AvanceModel(
      idEtapa: avance.idEtapa,
      comentario: avance.comentario,
      fecha: avance.fecha,
    );
  }

  Map<String, dynamic> toMap({
    required int idAvance,
  }) {
    return {
      'id_avance': idAvance,
      'id_etapa': idEtapa,
      'comentario': comentario.trim(),
      'fecha': fecha.toUtc().toIso8601String(),
    };
  }
}