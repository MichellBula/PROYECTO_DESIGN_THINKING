import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/proyect_data.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class ParticipantesPage extends StatelessWidget {
  final ProjectData project;

  const ParticipantesPage({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final participantes = [
      const _Participante(
        usuario: '@JuanPérez',
        rol: 'Líder',
      ),
      const _Participante(
        usuario: '@MichellBula',
        rol: 'Especialista en ondas',
      ),
      const _Participante(
        usuario: '@EmanuSiacho',
        rol: 'Admin de proyecto',
      ),
    ];

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenTitle(
              title: 'Lista de participantes',
              onBack: () {
                Navigator.pop(context);
              },
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: scheme.outlineVariant,
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  28,
                  20,
                  30,
                ),
                children: [
                  // NOMBRE DEL PROYECTO
                  Text(
                    project.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.formTitle.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 34),

                  // ENCABEZADOS
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Usuario',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardTitle.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Text(
                          'Rol',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardTitle.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // PARTICIPANTES
                  ...participantes.map(
                    (participante) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _ParticipanteRow(
                        participante: participante,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Participante {
  final String usuario;
  final String rol;

  const _Participante({
    required this.usuario,
    required this.rol,
  });
}

class _ParticipanteRow extends StatelessWidget {
  final _Participante participante;

  const _ParticipanteRow({
    required this.participante,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _ParticipantBox(
            text: participante.usuario,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _ParticipantBox(
            text: participante.rol,
          ),
        ),
      ],
    );
  }
}

class _ParticipantBox extends StatelessWidget {
  final String text;

  const _ParticipantBox({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 48,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyText.copyWith(
          color: scheme.onSurface,
        ),
      ),
    );
  }
}