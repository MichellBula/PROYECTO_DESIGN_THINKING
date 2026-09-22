import 'package:get/get.dart';

import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';

class SolicitudesController extends GetxController {
  // 0 = Recibidas, 1 = Enviadas
  final selectedTab = 0.obs;

  // Texto de búsqueda
  final searchQuery = ''.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  /// Lista según la pestaña activa
  List<Solicitud> get currentList {
    return selectedTab.value == 0
        ? solicitudesRecibidas
        : solicitudesEnviadas;
  }

  /// Lista filtrada por búsqueda (por proyecto)
  List<Solicitud> get filteredList {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return currentList;
    }

    return currentList.where((solicitud) {
      return solicitud.proyecto.toLowerCase().contains(query);
    }).toList();
  }

  /// Agrupa las solicitudes filtradas por proyecto
  Map<String, List<Solicitud>> get groupedByProject {
    final Map<String, List<Solicitud>> grouped = {};

    for (final solicitud in filteredList) {
      grouped.putIfAbsent(solicitud.proyecto, () => []);
      grouped[solicitud.proyecto]!.add(solicitud);
    }

    return grouped;
  }
}