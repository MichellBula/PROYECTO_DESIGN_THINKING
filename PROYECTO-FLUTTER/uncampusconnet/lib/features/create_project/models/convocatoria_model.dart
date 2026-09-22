import '../domain/entities/convocatoria.dart';

class ConvocatoriaModel extends Convocatoria {
  const ConvocatoriaModel({
    required super.idProyecto,
    required super.fechaInicio,
    required super.fechaFinal,
    required super.estado,
    required super.fechaLimiteDeAbandono,
  });

  factory ConvocatoriaModel.fromEntity(
    Convocatoria convocatoria,
  ) {
    return ConvocatoriaModel(
      idProyecto: convocatoria.idProyecto,
      fechaInicio: convocatoria.fechaInicio,
      fechaFinal: convocatoria.fechaFinal,
      estado: convocatoria.estado,
      fechaLimiteDeAbandono:
          convocatoria.fechaLimiteDeAbandono,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_proyecto': idProyecto,
      'fecha_inicio': fechaInicio
          .toUtc()
          .toIso8601String(),
      'fecha_final': fechaFinal
          .toUtc()
          .toIso8601String(),
      'estado': estado,
      'fecha_limite_de_abandono':
          fechaLimiteDeAbandono
              ?.toUtc()
              .toIso8601String(),
    };
  }
}