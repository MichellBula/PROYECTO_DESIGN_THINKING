import 'package:flutter/material.dart';

import 'package:uncampusconnet/features/home/widgets/events.dart';
import 'package:uncampusconnet/features/home/widgets/post_list.dart';

//Página Home principal
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HomeEvents(),
        Expanded(child: PostList()),
      ],
    );
  }
}