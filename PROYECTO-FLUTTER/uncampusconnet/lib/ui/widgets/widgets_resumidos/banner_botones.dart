import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/features/home/controllers/main_controller.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<MainController>();

    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _AppNavItem(
                icon: Icons.home_outlined,
                label: 'Inicio',
                isSelected: controller.currentIndex.value == 0,
                onTap: () => controller.changeTab(0),
              ),
            ),
            Expanded(
              child: _AppNavItem(
                icon: Icons.search,
                label: 'Buscar',
                isSelected: controller.currentIndex.value == 1,
                onTap: () => controller.changeTab(1),
              ),
            ),
            Expanded(
              child: _AppCreateButton(
                onTap: () {
                  // Get.to(() => const NuevoProyectoPage());
                },
              ),
            ),
            Expanded(
              child: _AppNavItem(
                icon: Icons.groups_outlined,
                label: 'Mis proyectos',
                isSelected: controller.currentIndex.value == 2,
                onTap: () => controller.changeTab(2),
              ),
            ),
            Expanded(
              child: _AppNavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Solicitudes',
                isSelected: controller.currentIndex.value == 3,
                onTap: () => controller.changeTab(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Navegacion
class _AppNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isSelected ? scheme.primary : scheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 3),
          Text(
            label,
            style: AppTextStyles.navLabel.copyWith(color: color),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

//Boton crear
class _AppCreateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AppCreateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, size: 25, color: scheme.onPrimary),
          ),
          const SizedBox(height: 3),
          Text(
            'Crear',
            style: AppTextStyles.navLabel.copyWith(color: scheme.primary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}