import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';
import 'package:uncampusconnet/ui/widgets/development_dialog.dart';
import 'package:uncampusconnet/ui/widgets/project_card.dart';

class MisProyectosPage extends StatelessWidget {
  const MisProyectosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.find<MainController>().changeTab(0);
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        size: 28,
                        color: scheme.onSurface,
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: Text(
                          'Mis proyectos',
                          style: AppTextStyles.screenTitle.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const Divider(),

              const SizedBox(height: 22),

              Container(
                height: 38,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(
                    AppTheme.cardRadius,
                  ),
                ),
                child: TextField(
                  style: AppTextStyles.smallText.copyWith(
                    color: scheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar por categoría',
                    hintStyle: AppTextStyles.smallText.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Expanded(
                child: ListView.separated(
                  itemCount: projects.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 28),
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    return ProjectCard(
                      title: project.title,
                      members: project.members,
                      role: project.role,
                      progress: project.progress,
                      onTap: () => showDevelopmentDialog(context),
                      onMenuTap: () => showDevelopmentDialog(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}