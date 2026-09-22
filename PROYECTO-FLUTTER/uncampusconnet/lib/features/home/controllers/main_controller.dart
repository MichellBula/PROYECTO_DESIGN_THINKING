import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';

import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';

class MainController extends GetxController {
  /// Índice de la pestaña actual:
  /// 0 = Inicio
  /// 1 = Buscar
  /// 2 = Crear
  /// 3 = Mis proyectos
  /// 4 = Solicitudes
  /// 5 = Detalle solicitud
  /// 6 = Chat con solicitante
  /// 7 = Detalle proyecto
  final currentIndex = 0.obs;

  final isDarkMode = false.obs;

  final selectedSolicitud = Rxn<Solicitud>();

  /// Proyecto seleccionado actualmente.
  final selectedProject = Rxn<ProjectData>();

  //Acciones
  void changeTab(int index) {
    currentIndex.value = index;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Abrir el detalle de una solicitud
  void openSolicitudDetalle(Solicitud solicitud) {
    selectedSolicitud.value = solicitud;
    currentIndex.value = 5;
  }

  /// Cerrar el detalle y volver a Solicitudes
  void closeSolicitudDetalle() {
    selectedSolicitud.value = null;
    currentIndex.value = 4;
  }

  /// Abrir chat con el solicitante
  void openChatSolicitud(Solicitud solicitud) {
    selectedSolicitud.value = solicitud;
    currentIndex.value = 6;
  }

  /// Cerrar chat y volver a detalles
  void closeChatSolicitud() {
    currentIndex.value = 5;
  }

  void openProjectDetail(ProjectData project) {
    selectedProject.value = project;
    currentIndex.value = 7;
  }

  /// Cierra el detalle del proyecto y vuelve a Mis proyectos.
  void closeProjectDetail() {
    selectedProject.value = null;
    currentIndex.value = 3;
  }
}

/// Abre el detalle del proyecto seleccionado.
///
/// Guarda el proyecto y cambia la vista a la pantalla
/// de detalle de proyectos.
