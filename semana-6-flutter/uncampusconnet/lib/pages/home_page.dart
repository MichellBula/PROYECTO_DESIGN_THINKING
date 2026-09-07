import 'package:flutter/material.dart';
import 'package:uncampusconnet/widgets/home_background.dart';
import 'package:uncampusconnet/widgets/header_banner.dart';
import 'package:uncampusconnet/widgets/quick_access_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const HomeBackground(),
          const HeaderBanner(),
          Positioned(left: 0, right: 0, bottom: 0, child: QuickAccessButtons()),
        ],
      ),
    );
  }
}
