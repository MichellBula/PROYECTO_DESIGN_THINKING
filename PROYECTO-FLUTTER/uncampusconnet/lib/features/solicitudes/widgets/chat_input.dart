import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/solicitudes/controllers/chat_controller.dart';

class ChatInput extends StatelessWidget {
  final ChatController controller;

  const ChatInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                style: AppTextStyles.bodyText,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Escribe tu mensaje',
                  hintStyle: AppTextStyles.bodyText.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.sendMessage,
              child: Icon(
                Icons.send_outlined,
                size: 22,
                color: scheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}