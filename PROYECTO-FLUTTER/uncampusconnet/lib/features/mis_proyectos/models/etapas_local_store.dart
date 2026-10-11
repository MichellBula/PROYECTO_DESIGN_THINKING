
import 'etapa_data.dart';

class EtapasLocalStore {
  EtapasLocalStore._();

  static final Map<int, List<EtapaData>> _etapasPorProyecto = {};

  static List<EtapaData> obtenerEtapas(int idProyecto) {
    return _etapasPorProyecto.putIfAbsent(
      idProyecto,
      () => <EtapaData>[],
    );
  }
}
