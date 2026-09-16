import 'package:flutter/material.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);

// ======================================================
// BARRA DE ACCESO RÁPIDO
// ======================================================

class QuickAccessButtons extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  // Callbacks opcionales para acciones especiales (como el botón Crear)
  final VoidCallback? onCrearTap;

  const QuickAccessButtons({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.onCrearTap,
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
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: Row(
        children: [
          // ==========================================
          // INICIO (índice 0)
          // ==========================================
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.home_outlined,
              label: 'Inicio',
              color: currentIndex == 0 ? primaryRed : defaultColor,
              onTap: () => onTabChanged(0),
            ),
          ),

          // ==========================================
          // BUSCAR (índice 1)
          // ==========================================
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.search,
              label: 'Buscar',
              color: currentIndex == 1 ? primaryRed : defaultColor,
              onTap: () => onTabChanged(1),
            ),
          ),

          // ==========================================
          // CREAR (acción especial, no cambia de página)
          // ==========================================
          Expanded(
            child: _CreateButton(
              onTap: onCrearTap ?? () {},
            ),
          ),

          // ==========================================
          // MIS PROYECTOS (índice 2)
          // ==========================================
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.groups_outlined,
              label: 'Mis proyectos',
              color: currentIndex == 2 ? primaryRed : defaultColor,
              onTap: () => onTabChanged(2),
            ),
          ),

          // ==========================================
          // SOLICITUDES (índice 3)
          // ==========================================
          Expanded(
            child: _QuickAccessButton(
              icon: Icons.chat_bubble_outline,
              label: 'Solicitudes',
              color: currentIndex == 3 ? primaryRed : defaultColor,
              onTap: () => onTabChanged(3),
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