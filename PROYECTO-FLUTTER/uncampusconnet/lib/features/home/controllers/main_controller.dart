import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MainController extends GetxController {
  /// Índice de la pestaña actual
  /// 0 = Inicio
  /// 1 = Buscar
  /// 2 = Crear
  /// 3 = Mis proyectos
  /// 4 = Solicitudes
  final currentIndex = 0.obs;

  /// Modo oscuro activo o no
  final isDarkMode = false.obs;

  /// Cambiar de pestaña
  void changeTab(int index) {
    currentIndex.value = index;
  }

  /// Cambiar entre modo claro y oscuro
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}