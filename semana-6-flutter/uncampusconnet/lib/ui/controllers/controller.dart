import 'package:get/get.dart';

class BuscarController extends GetxController {
  final searchText = ''.obs;

  final resultados = <String>[
    'Diseño de Software',
    'Inteligencia Artificial',
    'Bases de Datos',
    'Desarrollo Web',
    'Redes de Computadores',
  ].obs;

  void buscar(String texto) {
    searchText.value = texto;
  }
}

class SolicitudesController extends GetxController {
  final selectedTab = 0.obs;

  final recibidas = <String>[
    'Solicitud de Michell',
    'Solicitud de Sebastián',
    'Solicitud de Danaireth',
    'Solicitud de Paula',
  ].obs;

  final enviadas = <String>[
    'Solicitud enviada a Carlos',
    'Solicitud enviada a Laura',
    'Solicitud enviada a Andrés',
  ].obs;

  void cambiarTab(int index) {
    selectedTab.value = index;
  }
}
