import 'package:flutter/material.dart';

import 'package:uncampusconnet/features/mis_proyectos/models/etapa_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/pages/agregar_avance_page.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';

class DetalleEtapaPage extends StatefulWidget {
  final int numero;
  final EtapaData etapa;
  final ValueChanged<EtapaData> onChanged;

  const DetalleEtapaPage({
    super.key,
    required this.numero,
    required this.etapa,
    required this.onChanged,
  });

  @override
  State<DetalleEtapaPage> createState() =>
      _DetalleEtapaPageState();
}

class _DetalleEtapaPageState
    extends State<DetalleEtapaPage> {
  late EtapaData etapa;

  @override
  void initState() {
    super.initState();
    etapa = widget.etapa;
  }

  void _actualizar(EtapaData nuevaEtapa) {
    setState(() {
      etapa = nuevaEtapa;
    });

    widget.onChanged(nuevaEtapa);
  }

  Future<void> _agregarAvance() async {
    final avance = await Navigator.push<AvanceData>(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarAvancePage(
          numeroEtapa: widget.numero,
          nombreEtapa: etapa.etiqueta,
        ),
      ),
    );

    if (avance == null) return;

    _actualizar(
      etapa.copyWith(
        avances: [
          ...etapa.avances,
          avance,
        ],
      ),
    );
  }

  Future<void> _editarAvance(
    int index,
  ) async {
    final avance = await Navigator.push<AvanceData>(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarAvancePage(
          numeroEtapa: widget.numero,
          nombreEtapa: etapa.etiqueta,
          avance: etapa.avances[index],
        ),
      ),
    );

    if (avance == null) return;

    final nuevos = [...etapa.avances];
    nuevos[index] = avance;

    _actualizar(
      etapa.copyWith(
        avances: nuevos,
      ),
    );
  }

  Future<void> _eliminarAvance(
    int index,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Eliminar avance',
          ),
          content: const Text(
            '¿Deseas eliminar este avance?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Eliminar',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    final nuevos = [...etapa.avances];
    nuevos.removeAt(index);

    _actualizar(
      etapa.copyWith(
        avances: nuevos,
      ),
    );
  }

  String _fecha(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final porcentaje =
        (etapa.progreso * 100).round();

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
                padding:
                    const EdgeInsets.all(24),
                children: [
                  Text(
                    'Etapa #${widget.numero}: '
                    '${etapa.etiqueta}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child:
                            LinearProgressIndicator(
                          value: etapa.progreso,
                          minHeight: 10,
                          backgroundColor: scheme
                              .surfaceContainerHighest,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$porcentaje%',
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Descripción:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _InfoBox(
                    child: Text(
                      etapa.descripcion,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Fecha Fin:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _InfoBox(
                    child: Text(
                      _fecha(etapa.fechaFin),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Avances registrados:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (etapa.avances.isEmpty)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Text(
                        'Todavía no hay avances registrados.',
                        textAlign:
                            TextAlign.center,
                      ),
                    )
                  else
                    ...List.generate(
                      etapa.avances.length,
                      (index) {
                        final avance =
                            etapa.avances[index];

                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),
                          child: _InfoBox(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        'Hecho por: ${avance.autor}',
                                      ),
                                      Text(
                                        'Etiqueta: ${avance.etiqueta}',
                                      ),
                                      Text(
                                        'Fecha: ${_fecha(avance.fecha)}',
                                      ),
                                      if (avance
                                          .archivos
                                          .isNotEmpty) ...[
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${avance.archivos.length} archivo(s) adjunto(s)',
                                          style:
                                              TextStyle(
                                            color: scheme
                                                .primary,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                PopupMenuButton<
                                    String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                  ),
                                  onSelected:
                                      (value) {
                                    if (value ==
                                        'editar') {
                                      _editarAvance(
                                        index,
                                      );
                                    }

                                    if (value ==
                                        'eliminar') {
                                      _eliminarAvance(
                                        index,
                                      );
                                    }
                                  },
                                  itemBuilder:
                                      (_) => const [
                                    PopupMenuItem(
                                      value:
                                          'editar',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .edit_outlined,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Editar',
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value:
                                          'eliminar',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .delete_outline,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Eliminar',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: _agregarAvance,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          scheme.primary,
                      foregroundColor:
                          scheme.onPrimary,
                      minimumSize: const Size(
                        double.infinity,
                        50,
                      ),
                    ),
                    child: const Text(
                      'Agregar avance',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final Widget child;

  const _InfoBox({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}