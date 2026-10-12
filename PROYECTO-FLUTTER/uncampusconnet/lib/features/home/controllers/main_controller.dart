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
  /// 8 = Participantes
  /// 9 = Avances
  /// 10 = Eventos
  final currentIndex = 0.obs;

  final isDarkMode = false.obs;

  final selectedSolicitud = Rxn<Solicitud>();

  final selectedProject = Rxn<ProjectData>();
  final selectedProjectForParticipantes = Rxn<ProjectData>();
  final selectedProjectForAvances = Rxn<ProjectData>();
  final selectedProjectForEventos = Rxn<ProjectData>();

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void openSolicitudDetalle(Solicitud solicitud) {
    selectedSolicitud.value = solicitud;
    currentIndex.value = 5;
  }

  void closeSolicitudDetalle() {
    selectedSolicitud.value = null;
    currentIndex.value = 4;
  }

  void openChatSolicitud(Solicitud solicitud) {
    selectedSolicitud.value = solicitud;
    currentIndex.value = 6;
  }

  void closeChatSolicitud() {
    currentIndex.value = 5;
  }

  void openProjectDetail(ProjectData project) {
    selectedProject.value = project;
    currentIndex.value = 7;
  }

  void closeProjectDetail() {
    selectedProject.value = null;
    currentIndex.value = 3;
  }

  void openParticipantes(ProjectData project) {
    selectedProjectForParticipantes.value = project;
    currentIndex.value = 8;
  }

  void closeParticipantes() {
    selectedProjectForParticipantes.value = null;
    currentIndex.value = 7;
  }

  void openAvances(ProjectData project) {
    selectedProjectForAvances.value = project;
    currentIndex.value = 9;
  }

  void closeAvances() {
    selectedProjectForAvances.value = null;
    currentIndex.value = 7;
  }

  void openEventos(ProjectData project) {
    selectedProjectForEventos.value = project;
    currentIndex.value = 10;
  }

  void closeEventos() {
    selectedProjectForEventos.value = null;
    currentIndex.value = 7;
  }
}