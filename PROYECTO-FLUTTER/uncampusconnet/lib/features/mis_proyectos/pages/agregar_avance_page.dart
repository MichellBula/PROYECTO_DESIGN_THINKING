
import 'package:flutter/material.dart';
import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class AgregarAvancePage extends StatefulWidget {
  final int numeroEtapa;
  final String nombreEtapa;
  final AvanceData? avance;

  const AgregarAvancePage({
    super.key,
    required this.numeroEtapa,
    required this.nombreEtapa,
    this.avance,
  });

  @override
  State<AgregarAvancePage> createState() =>
      _AgregarAvancePageState();
}

class _AgregarAvancePageState extends State<AgregarAvancePage> {
  late final TextEditingController _etiquetaController;
  late final TextEditingController _descripcionController;

  late DateTime _fecha;
  late String _responsable;

  @override
  void initState() {
    super.initState();

    _etiquetaController = TextEditingController(
      text: widget.avance?.etiqueta ?? '',
    );

    _descripcionController = TextEditingController(
      text: widget.avance?.descripcion ?? '',
    );

    _fecha = widget.avance?.fecha ?? DateTime.now();

    // Temporal: se reemplazará por el usuario autenticado
    // cuando se conecte esta interfaz con Roble.
    _responsable =
        widget.avance?.autor ?? 'Usuario de la sesión actual';
  }

  @override
  void dispose() {
    _etiquetaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  void _guardarAvance() {
    final etiqueta = _etiquetaController.text.trim();
    final descripcion = _descripcionController.text.trim();

    if (etiqueta.isEmpty || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa el título y la descripción del avance.',
          ),
        ),
      );
      return;
    }

    final nuevoAvance = AvanceData(
      autor: _responsable,
      etiqueta: etiqueta,
      descripcion: descripcion,
      fecha: _fecha,
      archivos: widget.avance?.archivos ?? [],
    );

    Navigator.pop(context, nuevoAvance);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final esEdicion = widget.avance != null;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenTitle(
              title: esEdicion
                  ? 'Editar avance'
                  : 'Crear nuevo avance',
              onBack: () => Navigator.pop(context),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  22, 26, 22, 30,
                ),
                children: [
                  Text(
                    'Etapa #${widget.numeroEtapa}: '
                    '${widget.nombreEtapa}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    esEdicion
                        ? 'Actualiza la información del avance.'
                        : 'Registra las actividades realizadas '
                          'durante esta etapa.',
                    style: TextStyle(
                      fontSize: 15,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const _FormLabel(
                    text: 'Título del avance',
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _etiquetaController,
                    maxLength: 100,
                    decoration: _inputDecoration(
                      'Ej. Investigación inicial completada',
                    ),
                  ),

                  const SizedBox(height: 22),

                  const _FormLabel(
                    text: 'Responsable',
                  ),
                  const SizedBox(height: 8),
                  _ReadOnlyField(
                    icon: Icons.person_outline,
                    text: _responsable,
                  ),

                  const SizedBox(height: 22),

                  const _FormLabel(
                    text: 'Fecha del avance',
                  ),
                  const SizedBox(height: 8),
                  _ReadOnlyField(
                    icon: Icons.calendar_today_outlined,
                    text: _formatearFecha(_fecha),
                  ),

                  const SizedBox(height: 22),

                  const _FormLabel(
                    text: 'Descripción del avance',
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descripcionController,
                    minLines: 4,
                    maxLines: 7,
                    maxLength: 500,
                    decoration: _inputDecoration(
                      'Describe las actividades realizadas, '
                      'los resultados obtenidos y el progreso '
                      'alcanzado...',
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'El responsable y la fecha se '
                          'asignarán automáticamente.',
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _guardarAvance,
                          icon: Icon(
                            esEdicion
                                ? Icons.check
                                : Icons.save_outlined,
                          ),
                          label: Text(
                            esEdicion
                                ? 'Actualizar'
                                : 'Guardar avance',
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            backgroundColor: scheme.primary,
                            foregroundColor: scheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context)
          .colorScheme
          .surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;

  const _FormLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ReadOnlyField({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Icon(
            Icons.lock_outline,
            size: 17,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
