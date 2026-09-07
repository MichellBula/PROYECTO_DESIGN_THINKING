import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {
  const HeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

      decoration: BoxDecoration(
        color: Color.fromRGBO(226, 226, 226, 1),
        // borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/logo_encabezado.png', height: 50),

          const Spacer(),
          const Icon(Icons.notifications_none, size: 28),
          const SizedBox(width: 15),

          const Icon(Icons.person_outline, size: 28),
        ],
      ),
    );
  }
}
