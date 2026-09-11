import 'package:flutter/material.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);

// ======================================================
// ELEMENTO SELECCIONADO
// ======================================================

enum QuickAccessItem { inicio, buscar, crear, misProyectos, solicitudes }

// ======================================================
// BARRA DE ACCESO RÁPIDO
// ======================================================

class QuickAccessButtons extends StatelessWidget {
  final QuickAccessItem selectedItem;

  final VoidCallback? onInicioTap;
  final VoidCallback? onBuscarTap;
  final VoidCallback? onCrearTap;
  final VoidCallback? onMisProyectosTap;
  final VoidCallback? onSolicitudesTap;

  const QuickAccessButtons({
    super.key,
    required this.selectedItem,
    this.onInicioTap,
    this.onBuscarTap,
    this.onCrearTap,
    this.onMisProyectosTap,
    this.onSolicitudesTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color defaultColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 8),

      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: Row(
        children: [
          // ==========================================
          // INICIO
          // ==========================================

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.home_outlined,
              label: 'Inicio',

              color: selectedItem == QuickAccessItem.inicio
                  ? primaryRed
                  : defaultColor,

              onTap: onInicioTap ?? () {},
            ),
          ),

          // ==========================================
          // BUSCAR
          // ==========================================
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.search,
              label: 'Buscar',

              color: selectedItem == QuickAccessItem.buscar
                  ? primaryRed
                  : defaultColor,

              onTap: onBuscarTap ?? () {},
            ),
          ),

          // ==========================================
          // CREAR
          // ==========================================
          Expanded(child: _CreateButton(onTap: onCrearTap ?? () {})),

          // ==========================================
          // MIS PROYECTOS
          // ==========================================
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.groups_outlined,
              label: 'Mis proyectos',

              color: selectedItem == QuickAccessItem.misProyectos
                  ? primaryRed
                  : defaultColor,

              onTap: onMisProyectosTap ?? () {},
            ),
          ),

          // ==========================================
          // SOLICITUDES
          // ==========================================
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.chat_bubble_outline,
              label: 'Solicitudes',

              color: selectedItem == QuickAccessItem.solicitudes
                  ? primaryRed
                  : defaultColor,

              onTap: onSolicitudesTap ?? () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// BOTÓN NORMAL
// ======================================================

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(fontSize: 11, color: color),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ======================================================
// BOTÓN CREAR
// ======================================================

class _CreateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: primaryRed,
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.add, size: 25, color: Colors.white),
          ),

          const SizedBox(height: 3),

          const Text(
            'Crear',
            style: TextStyle(fontSize: 11, color: primaryRed),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
