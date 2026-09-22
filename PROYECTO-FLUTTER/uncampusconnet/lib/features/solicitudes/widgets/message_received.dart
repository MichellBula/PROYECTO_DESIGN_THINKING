import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/chat_avatar.dart';

class ChatMessageReceived extends StatelessWidget {
  final Mensaje mensaje;

  const ChatMessageReceived({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const ChatAvatar(size: 28),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(mensaje.texto, style: AppTextStyles.bodyText),
          ),
        ),
      ],
    );
  }
}