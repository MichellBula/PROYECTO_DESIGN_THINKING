import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';
import 'package:uncampusconnet/features/solicitudes/widgets/chat_avatar.dart';

class ChatMessageSent extends StatelessWidget {
  final Mensaje mensaje;

  const ChatMessageSent({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
        const SizedBox(width: 8),
        Column(
          children: [
            const ChatAvatar(size: 28),
            const SizedBox(height: 2),
            Text(
              'Tú',
              style: AppTextStyles.caption.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}