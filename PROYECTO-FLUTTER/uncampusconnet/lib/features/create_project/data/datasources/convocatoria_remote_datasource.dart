import 'package:roble/roble.dart';
import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/create_project/models/convocatoria_model.dart';

class ConvocatoriaRemoteDatasource {
  final RobleApiDataBase roble;

  ConvocatoriaRemoteDatasource({RobleApiDataBase? roble})
    : roble = roble ?? RobleClient.instance;

  Future<Map<String, dynamic>> createConvocatoria(
    ConvocatoriaModel convocatoria,
  ) async {
    print(
      '[CONVOCATORIA] Creando convocatoria '
      'para proyecto=${convocatoria.idProyecto}',
    );

    // -------------------------------------------------------
    // Verificar si ya existe
    // -------------------------------------------------------

    final existente = await roble.read(
      'convocatoria',
      filters: {'id_proyecto': convocatoria.idProyecto},
    );

    if (existente.isNotEmpty) {
      print(
        '[CONVOCATORIA] ⚠️ Ya existe una convocatoria. '
        'Se reutiliza.',
      );

      return Map<String, dynamic>.from(existente.first);
    }

    try {
      final resultado = await roble.create(
        'convocatoria',
        convocatoria.toMap(),
      );

      final mapa = Map<String, dynamic>.from(resultado);

      print('[CONVOCATORIA] ✅ Convocatoria creada.');

      print('[CONVOCATORIA] Resultado: $mapa');

      return mapa;
    } catch (e) {
      print('[CONVOCATORIA] ⚠️ Error: $e');

      // -----------------------------------------------------
      // Posiblemente Roble sí la creó pero la respuesta
      // falló/tardó. Volvemos a leer antes de devolver error.
      // -----------------------------------------------------

      final creadaDespuesDelError = await roble.read(
        'convocatoria',
        filters: {'id_proyecto': convocatoria.idProyecto},
      );

      if (creadaDespuesDelError.isNotEmpty) {
        print(
          '[CONVOCATORIA] ⚠️ La convocatoria '
          'sí existe después del error.',
        );

        print('[CONVOCATORIA] Se reutiliza.');

        return Map<String, dynamic>.from(creadaDespuesDelError.first);
      }

      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getConvocatoriaByProject(int idProyecto) async {
    final resultado = await roble.read(
      'convocatoria',
      filters: {'id_proyecto': idProyecto},
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(resultado.first);
  }
}
