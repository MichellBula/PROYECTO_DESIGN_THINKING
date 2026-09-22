import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/core/utils/app_scroll_behavior.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/main_scaffold.dart';

void main() {
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
      scrollBehavior: AppScrollBehavior(), 
      home: const MainScaffold(),
    );
  }
}