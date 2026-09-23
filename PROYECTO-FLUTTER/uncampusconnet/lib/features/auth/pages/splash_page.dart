import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/auth/pages/completar_perfil_page.dart';
import 'package:uncampusconnet/features/auth/pages/login_page.dart';
import 'package:uncampusconnet/ui/widgets/main_scaffold.dart';



class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controller = Get.put(SesionController());

  @override
  void initState() {
    super.initState();
    _decidir();
  }

  Future<void> _decidir() async {
    // Espera un momento (para que se vea el logo)
    await Future.delayed(const Duration(milliseconds: 800));

    // Intenta restaurar sesión
    try {
      await controller.restaurarSesion();
    } catch (e) {
      // No hay sesión guardada, ignorar error
    }

    if (!mounted) return;

    // Decide a dónde ir
    if (controller.estaAutenticado) {
      if (controller.necesitaCompletarPerfil) {
        Get.offAll(() => const CompletarPerfilPage());
      } else {
        Get.offAll(() => const MainScaffold());
      }
    } else {
      Get.offAll(() => LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset(
              'assets/images/logo.png',
              height: 120,
            ),

            const SizedBox(height: 30),

            // LOADING
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}