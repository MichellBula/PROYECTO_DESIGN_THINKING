import 'package:flutter/material.dart';

import 'package:uncampusconnet/widgets/home_background.dart';
import 'package:uncampusconnet/widgets/header_banner.dart';
import 'package:uncampusconnet/widgets/quick_access_buttons.dart';
import 'package:uncampusconnet/widgets/home_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const HomeBackground(),

          const HeaderBanner(),

          const Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 75,
            child: HomeEvents(),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: QuickAccessButtons(),
          ),
        ],
      ),
    );
  }
}