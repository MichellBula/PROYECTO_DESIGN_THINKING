import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';


class ChatController extends GetxController {
  /// Lista de mensajes
  final mensajes = <Mensaje>[].obs;

  /// Si el otro usuario está escribiendo
  final isTyping = false.obs;

  /// Controlador del campo de texto
  final textController = TextEditingController();

  /// Controlador de scroll
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    // Mensaje inicial
    mensajes.add(const Mensaje(
      texto:
          'Hola!!, me gustó mucho tu solicitud, podríamos agendar una entrevista para conocerte más??',
      isMine: true,
    ));

    // Simula que el otro usuario responde
    _simulateTyping();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// Enviar un mensaje
  void sendMessage() {
    final texto = textController.text.trim();
    if (texto.isEmpty) return;

    mensajes.add(Mensaje(texto: texto, isMine: true));
    textController.clear();
    _scrollToBottom();
    _simulateReply();
  }

  /// Simula que el otro usuario escribe al entrar
  void _simulateTyping() {
    Future.delayed(const Duration(seconds: 2), () {
      isTyping.value = true;
      _scrollToBottom();

      Future.delayed(const Duration(seconds: 2), () {
        isTyping.value = false;
        mensajes.add(const Mensaje(
          texto: 'Hola! Claro, me encantaría. ¿Cuándo te queda bien?',
          isMine: false,
        ));
        _scrollToBottom();
      });
    });
  }

  /// Simula respuesta automática
  void _simulateReply() {
    Future.delayed(const Duration(seconds: 1), () {
      isTyping.value = true;
      _scrollToBottom();

      Future.delayed(const Duration(seconds: 2), () {
        isTyping.value = false;
        mensajes.add(const Mensaje(
          texto: 'Perfecto, hablamos pronto 😊',
          isMine: false,
        ));
        _scrollToBottom();
      });
    });
  }

  /// Scroll al final
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}