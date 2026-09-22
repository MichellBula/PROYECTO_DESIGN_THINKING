import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';
import 'package:uncampusconnet/features/home/widgets/post_card.dart';

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // TÍTULO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Publicaciones:',
            style: AppTextStyles.sectionTitle.copyWith(color: scheme.onSurface),
          ),
        ),

        const SizedBox(height: 12),

        // LISTA
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              return PostCard(post: posts[index]);
            },
          ),
        ),
      ],
    );
  }
}
