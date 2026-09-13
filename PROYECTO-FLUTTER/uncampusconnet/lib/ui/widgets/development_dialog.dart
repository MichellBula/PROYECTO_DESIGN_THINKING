import 'package:flutter/material.dart';

const Color primaryRed = Color(0xFF931212);
const Color secondaryPink = Color(0xFFC9ACAC);

void showDevelopmentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 28, 25, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==========================================
              // ICONO
              // ==========================================

              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: secondaryPink.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction_outlined,
                  color: primaryRed,
                  size: 34,
                ),
              ),

              const SizedBox(height: 18),

              // ==========================================
              // TÍTULO
              // ==========================================
              const Text(
                'En desarrollo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryRed,
                ),
              ),

              const SizedBox(height: 10),

              // ==========================================
              // DESCRIPCIÓN
              // ==========================================
              const Text(
                'Esta función estará disponible próximamente.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 22),

              // ==========================================
              // BOTÓN
              // ==========================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Entendido',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
