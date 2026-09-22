import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/solicitudes/controllers/chat_controller.dart';
import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/chat_avatar.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/chat_input.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/message_received.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/message_send.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/chat_typing.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class ChatSolicitudPage extends StatelessWidget {
  final Solicitud solicitud;

  const ChatSolicitudPage({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    final controller = Get.put(ChatController());
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AppScreenTitle(
          title: 'Chat',
          onBack: () => mainController.closeChatSolicitud(),
        ),

        // ENCABEZADO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              const ChatAvatar(size: 32),
              const SizedBox(width: 10),
              Text(solicitud.usuario, style: AppTextStyles.cardTitle),
            ],
          ),
        ),

        const Divider(height: 1),

        // MENSAJES
        Expanded(
          child: Obx(
            () => ListView(
              controller: controller.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                Center(
                  child: Text(
                    'Hoy',
                    style: AppTextStyles.caption.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ...controller.mensajes.map(
                  (mensaje) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: mensaje.isMine
                        ? ChatMessageSent(mensaje: mensaje)
                        : ChatMessageReceived(mensaje: mensaje),
                  ),
                ),

                if (controller.isTyping.value) const ChatTypingIndicator(),
              ],
            ),
          ),
        ),

        // INPUT
        ChatInput(controller: controller),
      ],
    );
  }
}
