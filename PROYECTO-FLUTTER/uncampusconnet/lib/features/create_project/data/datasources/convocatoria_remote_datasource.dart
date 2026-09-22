import 'package:roble/roble.dart';

import '../../../../core/database/roble_client.dart';
import '../../models/convocatoria_model.dart';

class ConvocatoriaRemoteDatasource {
  final RobleApiDataBase roble;

  ConvocatoriaRemoteDatasource({
    RobleApiDataBase? roble,
  }) : roble = roble ?? RobleClient.instance;

  Future<Map<String, dynamic>> createConvocatoria(
    ConvocatoriaModel convocatoria,
  ) async {
    final existente = await roble.read(
      'convocatoria',
      filters: {
        'id_proyecto': convocatoria.idProyecto,
      },
    );

    if (existente.isNotEmpty) {
      return Map<String, dynamic>.from(
        existente.first,
      );
    }

    final resultado = await roble.create(
      'convocatoria',
      convocatoria.toMap(),
    );

    return Map<String, dynamic>.from(
      resultado,
    );
  }

  Future<Map<String, dynamic>?> getConvocatoriaByProject(
    int idProyecto,
  ) async {
    final resultado = await roble.read(
      'convocatoria',
      filters: {
        'id_proyecto': idProyecto,
      },
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(
      resultado.first,
    );
  }
}