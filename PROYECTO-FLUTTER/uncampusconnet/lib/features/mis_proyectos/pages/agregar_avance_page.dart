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

class _AgregarAvancePageState
    extends State<AgregarAvancePage> {
  late final TextEditingController _etiquetaController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _encargadoController;

  final List<String> _archivos = [];

  @override
  void initState() {
    super.initState();

    _etiquetaController = TextEditingController(
      text: widget.avance?.etiqueta ?? '',
    );

    _descripcionController = TextEditingController(
      text: widget.avance?.descripcion ?? '',
    );

    _encargadoController = TextEditingController(
      text: widget.avance?.autor ?? '',
    );

    _archivos.addAll(
      widget.avance?.archivos ?? [],
    );
  }

  @override
  void dispose() {
    _etiquetaController.dispose();
    _descripcionController.dispose();
    _encargadoController.dispose();
    super.dispose();
  }

  void _adjuntarArchivo() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Adjuntar archivo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Por ahora agregaremos un archivo de prueba. '
                  'Después conectaremos el selector real de archivos.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _archivos.add(
                        'archivo_${_archivos.length + 1}.pdf',
                      );
                    });

                    Navigator.pop(sheetContext);
                  },
                  icon: const Icon(
                    Icons.upload_file,
                  ),
                  label: const Text(
                    'Agregar archivo',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _eliminarArchivo(int index) {
    setState(() {
      _archivos.removeAt(index);
    });
  }

  void _guardar() {
    final etiqueta =
        _etiquetaController.text.trim();

    final descripcion =
        _descripcionController.text.trim();

    final encargado =
        _encargadoController.text.trim();

    if (etiqueta.isEmpty ||
        descripcion.isEmpty ||
        encargado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa etiqueta, descripción y encargado.',
          ),
        ),
      );
      return;
    }

    final avance = AvanceData(
      autor: encargado,
      etiqueta: etiqueta,
      descripcion: descripcion,
      fecha: widget.avance?.fecha ?? DateTime.now(),
      archivos: List<String>.from(_archivos),
    );

    Navigator.pop(
      context,
      avance,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenTitle(
              title: 'Avances',
              onBack: () {
                Navigator.pop(context);
              },
            ),

            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  28,
                  22,
                  30,
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

                  const SizedBox(height: 30),

                  _FormLabel(
                    text: 'Etiqueta:',
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _etiquetaController,
                    decoration: _inputDecoration(
                      'Etiqueta del avance',
                    ),
                  ),

                  const SizedBox(height: 26),

                  _FormLabel(
                    text: 'Descripción:',
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _descripcionController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: _inputDecoration(
                      'Durante esta etapa...',
                    ),
                  ),

                  const SizedBox(height: 26),

                  _FormLabel(
                    text: 'Encargado:',
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _encargadoController,
                    decoration: _inputDecoration(
                      '@integrante',
                    ),
                  ),

                  const SizedBox(height: 30),

                  _FormLabel(
                    text: 'Adjuntar archivos:',
                  ),

                  const SizedBox(height: 8),

                  InkWell(
                    borderRadius:
                        BorderRadius.circular(12),
                    onTap: _adjuntarArchivo,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        color:
                            scheme.surfaceContainerLowest,
                        borderRadius:
                            BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withValues(
                              alpha: 0.15,
                            ),
                            blurRadius: 5,
                            offset:
                                const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '.png, .pdf, .zip',
                              style: TextStyle(
                                color:
                                    scheme.onSurfaceVariant,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.upload_outlined,
                            color: scheme.onSurface,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_archivos.isNotEmpty) ...[
                    const SizedBox(height: 14),

                    ...List.generate(
                      _archivos.length,
                      (index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: scheme
                                  .surfaceContainerHighest,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.attach_file,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _archivos[index],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _eliminarArchivo(
                                      index,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 60),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  scheme.primary,
                              foregroundColor:
                                  scheme.onPrimary,
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _guardar,
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  scheme.primary,
                              foregroundColor:
                                  scheme.onPrimary,
                            ),
                            child: Text(
                              widget.avance == null
                                  ? 'Guardar'
                                  : 'Actualizar',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
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

  InputDecoration _inputDecoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color:
              Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;

  const _FormLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}