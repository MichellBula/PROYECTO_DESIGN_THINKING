import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/theme.dart';

class ChatAvatar extends StatelessWidget {
  final double size;

  const ChatAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppTheme.buttonRed,
        shape: BoxShape.circle,
      ),
    );
  }
}