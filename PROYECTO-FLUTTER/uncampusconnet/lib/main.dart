import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/core/utils/app_scroll_behavior.dart';
import 'package:uncampusconnet/features/auth/pages/splash_page.dart';

Future<void> main() async {
  // Necesario antes de inicializar servicios que
  // puedan necesitar comunicación con Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  //Iniciar aplicacion
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'UnCampusConnect',

      // Tema
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,

      scrollBehavior: AppScrollBehavior(),

      // Pantalla inicial
      home: const SplashPage(),
    );
  }
}