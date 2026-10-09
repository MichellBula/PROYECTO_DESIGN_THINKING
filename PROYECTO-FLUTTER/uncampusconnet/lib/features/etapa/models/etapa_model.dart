import '../domain/entities/etapa.dart';

class EtapaModel extends Etapa {
  const EtapaModel({
    required super.idProyecto,
    required super.nombreEtapa,
    required super.orden,
  });

  factory EtapaModel.fromEntity(Etapa etapa) {
    return EtapaModel(
      idProyecto: etapa.idProyecto,
      nombreEtapa: etapa.nombreEtapa,
      orden: etapa.orden,
    );
  }

  Map<String, dynamic> toMap({
    required int idEtapa,
  }) {
    return {
      'id_etapa': idEtapa,
      'id_proyecto': idProyecto,
      'nombre_etapa': nombreEtapa,
      'orden': orden,
    };
  }
}