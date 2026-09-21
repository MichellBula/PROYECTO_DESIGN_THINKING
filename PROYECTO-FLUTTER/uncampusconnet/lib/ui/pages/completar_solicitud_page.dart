import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/ui/widgets/information_list.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/screen_title.dart';

class CompletarSolicitudPage extends StatefulWidget {
  final ProjectInfo project;

  const CompletarSolicitudPage({
    super.key,
    required this.project,
  });

  @override
  State<CompletarSolicitudPage> createState() =>
      _CompletarSolicitudPageState();
}

class _CompletarSolicitudPageState extends State<CompletarSolicitudPage> {
  final _formKey = GlobalKey<FormState>();

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

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu correo electrónico';
    }

    if (!value.contains('@')) {
      return 'Ingresa un correo válido';
    }

    return null;
  }

  void _enviarSolicitud() {
    if (!_formKey.currentState!.validate()) return;

    // Más adelante aquí se guardará la solicitud
    // en la base de datos.

    _mostrarSolicitudEnviada();
  }

  void _mostrarSolicitudEnviada() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _SuccessDialog(
        projectName: widget.project.name,
        onClose: () => _cerrarSolicitud(dialogContext),
      ),
    );
  }

  void _cerrarSolicitud(BuildContext dialogContext) {
    Navigator.pop(dialogContext);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 12,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(-12, 0),
                  child: const AppScreenTitle(
                    title: 'Completar solicitud',
                  ),
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

                _FormField(
                  label: 'Nombre completo',
                  controller: _nombreController,
                  hintText: 'Escribe tu nombre completo',
                  validator: (value) => _requiredValidator(
                    value,
                    'Ingresa tu nombre completo',
                  ),
                ),

                _FormField(
                  label: 'Correo electrónico',
                  controller: _correoController,
                  hintText: 'ejemplo@correo.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailValidator,
                ),

                _FormField(
                  label: 'Carrera',
                  controller: _carreraController,
                  hintText: 'Ej. Ingeniería de Sistemas',
                  validator: (value) => _requiredValidator(
                    value,
                    'Ingresa tu carrera',
                  ),
                ),

                _FormField(
                  label: 'Semestre',
                  controller: _semestreController,
                  hintText: 'Ej. 8',
                  keyboardType: TextInputType.number,
                  validator: (value) => _requiredValidator(
                    value,
                    'Ingresa tu semestre',
                  ),
                ),

                _FormField(
                  label: '¿Por qué desea unirse al proyecto?',
                  controller: _motivoController,
                  hintText:
                      'Cuéntanos brevemente por qué quieres participar',
                  maxLines: 4,
                  validator: (value) => _requiredValidator(
                    value,
                    'Cuéntanos por qué deseas unirte',
                  ),
                ),

                _RoleDropdown(
                  roles: widget.project.roles,
                  selectedRole: _rolSeleccionado,
                  onChanged: (value) {
                    setState(() {
                      _rolSeleccionado = value;
                    });
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
                            side: BorderSide(
                              color: scheme.primary,
                            ),
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
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final int maxLines;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.fieldLabel.copyWith(
              color: scheme.onSurface,
            ),
          ),

          const SizedBox(height: 7),

          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            style: AppTextStyles.bodyText.copyWith(
              color: scheme.onSurface,
            ),
            decoration: _fieldDecoration(
              context,
              hintText,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleDropdown extends StatelessWidget {
  final List<String> roles;
  final String? selectedRole;
  final ValueChanged<String?> onChanged;

  const _RoleDropdown({
    required this.roles,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rol deseado',
          style: AppTextStyles.fieldLabel.copyWith(
            color: scheme.onSurface,
          ),
        ),

        const SizedBox(height: 7),

        DropdownButtonFormField<String>(
          initialValue: selectedRole,
          isExpanded: true,
          decoration: _fieldDecoration(
            context,
            'Selecciona un rol',
          ),
          items: roles
              .map(
                (role) => DropdownMenuItem(
                  value: role,
                  child: Text(
                    role,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return 'Selecciona un rol';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final String projectName;
  final VoidCallback onClose;

  const _SuccessDialog({
    required this.projectName,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppTheme.cardRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          28,
          36,
          28,
          28,
        ),
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
              style: AppTextStyles.formTitle.copyWith(
                color: scheme.onSurface,
              ),
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

InputDecoration _fieldDecoration(
  BuildContext context,
  String hintText,
) {
  final scheme = Theme.of(context).colorScheme;

  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        AppTheme.smallRadius,
      ),
      borderSide: BorderSide(
        color: color,
      ),
    );
  }

  return InputDecoration(
    hintText: hintText,
    hintStyle: AppTextStyles.bodyText.copyWith(
      color: scheme.onSurfaceVariant,
    ),
    filled: true,
    fillColor: scheme.surfaceContainerHighest,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        AppTheme.smallRadius,
      ),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        AppTheme.smallRadius,
      ),
      borderSide: BorderSide.none,
    ),
    errorBorder: border(scheme.error),
    focusedErrorBorder: border(scheme.error),
  );
}