import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart';
import 'package:uncampusconnet/ui/widgets/info_field.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class SolicitudDetallePage extends StatelessWidget {
  final Solicitud solicitud;

  const SolicitudDetallePage({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mainController = Get.find<MainController>();

    return Column(
      children: [
        // TÍTULO
        AppScreenTitle(
          title: 'Solicitud #001',
          onBack: () => mainController.closeSolicitudDetalle(),
        ),

        // CONTENIDO
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            children: [
              // AVATAR
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    color: AppTheme.buttonRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // USUARIO
              Center(
                child: Text(
                  solicitud.usuario,
                  style: AppTextStyles.greeting.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // CAMPOS
              InfoField(label: 'Nombre completo:', value: solicitud.nombre),
              const SizedBox(height: 16),
              InfoField(label: 'Carrera:', value: solicitud.carrera),
              const SizedBox(height: 16),
              InfoField(label: 'Semestre:', value: solicitud.semestre),
              const SizedBox(height: 16),
              InfoField(
                label: '¿Por qué está interesado?:',
                value: solicitud.motivo,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              InfoField(label: 'Rol deseado:', value: solicitud.cargo),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () => mainController.openChatSolicitud(solicitud),
                  child: Text(
                    'Solicitar entrevista por el chat',
                    style: AppTextStyles.smallText.copyWith(
                      color: AppTheme.primaryRed,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.primaryRed,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // BOTONES
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      text: 'Rechazar',
                      onPressed: () {
                        Get.snackbar(
                          'Rechazada',
                          'Rechazaste la solicitud de ${solicitud.nombre}',
                        );
                        mainController.closeSolicitudDetalle();
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _ActionButton(
                      text: 'Aceptar',
                      onPressed: () {
                        Get.snackbar(
                          'Aceptada',
                          'Aceptaste la solicitud de ${solicitud.nombre}',
                        );
                        mainController.closeSolicitudDetalle();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _ActionButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: AppTextStyles.buttonText),
      ),
    );
  }
}
