import 'package:flutter/material.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';
import 'package:uncampusconnet/features/buscar/pages/completar_solicitud_page.dart';
import 'package:uncampusconnet/ui/widgets/widgets_resumidos/cards_wrapper.dart';


class ProyectoDisponiblePage extends StatelessWidget {
  final ProjectInfo project;

  const ProyectoDisponiblePage({
    super.key,
    required this.project,
  });

  bool get _isAvailable {
    final parts = project.closingDate.split('/');
    if (parts.length != 3) return false;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return false;

    final closingDate = DateTime(
      year,
      month,
      day,
      23,
      59,
      59,
    );

    return !DateTime.now().isAfter(closingDate);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Proyecto disponible',
                        style: AppTextStyles.screenTitle.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.chevron_left,
                          size: 28,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _ProjectHeader(project: project),

              const SizedBox(height: 28),

              const _SectionTitle('Descripción:'),

              const SizedBox(height: 10),

              CardWrapper(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    project.description,
                    style: AppTextStyles.bodyText.copyWith(
                      color: scheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const _SectionTitle('Requisitos:'),

              const SizedBox(height: 10),

              CardWrapper(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: project.requirements
                        .map(
                          (requirement) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '•',
                                  style: AppTextStyles.bodyText.copyWith(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    requirement,
                                    style: AppTextStyles.bodyText.copyWith(
                                      color: scheme.onSurface,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const _SectionTitle('Roles disponibles:'),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.roles
                    .map(
                      (role) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            AppTheme.cardRadius,
                          ),
                        ),
                        child: Text(
                          role,
                          style: AppTextStyles.bodyText.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              const _SectionTitle('Fecha cierre convocatoria:'),

              const SizedBox(height: 12),

              Container(
                width: 210,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(
                    AppTheme.eventCardRadius,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: scheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      project.closingDate,
                      style: AppTextStyles.bodyText.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              _ProjectActionButton(
                project: project,
                isAvailable: _isAvailable,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  final ProjectInfo project;

  const _ProjectHeader({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: scheme.primary,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: AppTextStyles.greeting.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${project.members} integrantes',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${project.vacancies} vacantes',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Líder: ${project.leader}',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                project.area,
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Text(
      title,
      style: AppTextStyles.screenTitle.copyWith(
        color: scheme.onSurface,
      ),
    );
  }
}

class _ProjectActionButton extends StatelessWidget {
  final ProjectInfo project;
  final bool isAvailable;

  const _ProjectActionButton({
    required this.project,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (!isAvailable) {
      return Container(
        width: double.infinity,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(
            AppTheme.smallRadius,
          ),
        ),
        child: Text(
          'Convocatoria cerrada',
          style: AppTextStyles.buttonText.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompletarSolicitudPage(
                project: project,
              ),
            ),
          );
        },
        child: const Text('Postularse'),
      ),
    );
  }
}