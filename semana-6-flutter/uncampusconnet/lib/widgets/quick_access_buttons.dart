import 'package:flutter/material.dart';

// ======================================================
// COLORES
// ======================================================

const Color primaryRed = Color(0xFF931212);

// ======================================================
// ELEMENTO SELECCIONADO
// ======================================================

enum QuickAccessItem {
  inicio,
  buscar,
  crear,
  misProyectos,
  solicitudes,
}

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
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 8,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),

      child: Row(
        children: [
          // ==================================================
          // INICIO
          // ==================================================

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.home_outlined,
              label: 'Inicio',
              color: selectedItem == QuickAccessItem.inicio
                  ? primaryRed
                  : Colors.black,
              onTap: onInicioTap ?? () {},
            ),
          ),

          // ==================================================
          // BUSCAR
          // ==================================================

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.search,
              label: 'Buscar',
              color: selectedItem == QuickAccessItem.buscar
                  ? primaryRed
                  : Colors.black,
              onTap: onBuscarTap ?? () {},
            ),
          ),

          // ==================================================
          // CREAR
          // ==================================================

          Expanded(
            child: _CreateButton(
              onTap: onCrearTap ?? () {},
            ),
          ),

          // ==================================================
          // MIS PROYECTOS
          // ==================================================

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.groups_outlined,
              label: 'Mis proyectos',
              color:
                  selectedItem == QuickAccessItem.misProyectos
                      ? primaryRed
                      : Colors.black,
              onTap: onMisProyectosTap ?? () {},
            ),
          ),

          // ==================================================
          // SOLICITUDES
          // ==================================================

          Expanded(
            child: _QuickAccessButton(
              icon: Icons.chat_bubble_outline,
              label: 'Solicitudes',
              color:
                  selectedItem == QuickAccessItem.solicitudes
                      ? primaryRed
                      : Colors.black,
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
          Icon(
            icon,
            size: 30,
            color: color,
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w400,
            ),
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

  const _CreateButton({
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
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: primaryRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            'Crear',
            style: TextStyle(
              fontSize: 11,
              color: primaryRed,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}