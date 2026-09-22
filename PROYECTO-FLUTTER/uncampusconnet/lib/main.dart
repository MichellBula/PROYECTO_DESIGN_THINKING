import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/theme.dart';

import 'package:uncampusconnet/core/utils/app_scroll_behavior.dart';

//import 'package:uncampusconnet/core/database/test_roble.dart';

import 'package:uncampusconnet/ui/widgets/widgets_resumidos/main_scaffold.dart';

Future<void> main() async {
  // Necesario antes de inicializar servicios que
  // puedan necesitar comunicación con Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================
  // PRUEBA TEMPORAL DE ROBLE
  // ==========================================

  //await probarRoble();

  // ==========================================
  // INICIAR APLICACIÓN
  // ==========================================

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'UnCampusConnect',

      theme: AppTheme.light,

      darkTheme: AppTheme.dark,

      themeMode: ThemeMode.light,
<<<<<<< Updated upstream
      scrollBehavior: AppScrollBehavior(), 
=======

      scrollBehavior: AppScrollBehavior(),

>>>>>>> Stashed changes
      home: const MainScaffold(),
    );
  }
}
