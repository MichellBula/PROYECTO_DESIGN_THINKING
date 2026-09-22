import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';
import 'package:uncampusconnet/ui/widgets/dropdown_field.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';
import 'package:uncampusconnet/ui/widgets/text_field.dart';

class CompletarSolicitudPage extends StatefulWidget {
  final ProjectInfo project;

  const CompletarSolicitudPage({super.key, required this.project});

  @override
  State<CompletarSolicitudPage> createState() => _CompletarSolicitudPageState();
}

class _CompletarSolicitudPageState extends State<CompletarSolicitudPage> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _carreraController = TextEditingController();
  final _semestreController = TextEditingController();
  final _motivoController = TextEditingController();

  String? _rolSeleccionado;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _carreraController.dispose();
    _semestreController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  void _enviarSolicitud() {
    final camposVacios = [
      _nombreController,
      _correoController,
      _carreraController,
      _semestreController,
      _motivoController,
    ].any((controller) => controller.text.trim().isEmpty);

    if (camposVacios || _rolSeleccionado == null) {
      _mostrarMensaje('Completa todos los campos.');
      return;
    }

    if (!_correoController.text.contains('@')) {
      _mostrarMensaje('Ingresa un correo electrónico válido.');
      return;
    }

    _mostrarSolicitudEnviada();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _mostrarSolicitudEnviada() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _SuccessDialog(
        projectName: widget.project.name,
        onClose: () {
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(-12, 0),
                child: const AppScreenTitle(title: 'Completar solicitud'),
              ),

              const SizedBox(height: 24),

              Text(
                'Postulación a ${widget.project.name}',
                style: AppTextStyles.screenTitle.copyWith(
                  color: scheme.onSurface,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Completa la información para enviar tu solicitud.',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              AppTextField(
                label: 'Nombre completo',
                hint: 'Escribe tu nombre completo',
                controller: _nombreController,
                maxLength: 100,
              ),

              const SizedBox(height: 18),

              AppTextField(
                label: 'Correo electrónico',
                hint: 'ejemplo@correo.com',
                controller: _correoController,
                maxLength: 100,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              AppTextField(
                label: 'Carrera',
                hint: 'Ej. Ingeniería de Sistemas',
                controller: _carreraController,
                maxLength: 100,
              ),

              const SizedBox(height: 18),

              AppTextField(
                label: 'Semestre',
                hint: 'Ej. 8',
                controller: _semestreController,
                maxLength: 2,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 18),

              AppTextField(
                label: '¿Por qué desea unirse al proyecto?',
                hint: 'Cuéntanos brevemente por qué quieres participar',
                controller: _motivoController,
                maxLength: 500,
                maxLines: 4,
              ),

              const SizedBox(height: 18),

              AppDropdownField(
                label: 'Rol deseado',
                hint: 'Selecciona un rol',
                value: _rolSeleccionado,
                items: widget.project.roles,
                onChanged: (value) {
                  setState(() => _rolSeleccionado = value);
                },
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.primary,
                          side: BorderSide(color: scheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.smallRadius,
                            ),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _enviarSolicitud,
                        child: const Text('Enviar'),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final String projectName;
  final VoidCallback onClose;

  const _SuccessDialog({required this.projectName, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 70,
                color: scheme.onPrimary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              '¡Tu solicitud fue enviada\ncon éxito!',
              textAlign: TextAlign.center,
              style: AppTextStyles.formTitle.copyWith(color: scheme.onSurface),
            ),

            const SizedBox(height: 10),

            Text(
              'Tu postulación a $projectName fue registrada.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Está atent@ a tus notificaciones para '
              'conocer los cambios en tu solicitud.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onClose,
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
