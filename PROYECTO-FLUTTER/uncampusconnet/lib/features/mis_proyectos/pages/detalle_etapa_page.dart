
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
  State<DetalleEtapaPage> createState() => _DetalleEtapaPageState();
}

class _DetalleEtapaPageState extends State<DetalleEtapaPage> {
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

    if (!mounted || avance == null) return;

    _actualizar(
      etapa.copyWith(
        avances: [...etapa.avances, avance],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avance agregado correctamente'),
      ),
    );
  }

  Future<void> _editarAvance(int index) async {
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

    if (!mounted || avance == null) return;

    final nuevos = [...etapa.avances];
    nuevos[index] = avance;

    _actualizar(etapa.copyWith(avances: nuevos));
  }

  Future<void> _eliminarAvance(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar avance'),
        content: const Text(
          '¿Deseas eliminar este avance?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;

    final nuevos = [...etapa.avances];
    nuevos.removeAt(index);

    _actualizar(etapa.copyWith(avances: nuevos));
  }

  String _fecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progreso = etapa.progreso.clamp(0.0, 1.0);
    final porcentaje = (progreso * 100).round();

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenTitle(
              title: 'Detalle de etapa',
              onBack: () => Navigator.pop(context),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    'Etapa #${widget.numero}: ${etapa.etiqueta}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progreso de la etapa',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$porcentaje%',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progreso,
                      minHeight: 10,
                      backgroundColor:
                          scheme.surfaceContainerHighest,
                      color: scheme.primary,
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    'Descripción de la etapa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _InfoBox(
                    child: Text(etapa.descripcion),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Fecha de finalización',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _InfoBox(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 19,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(_fecha(etapa.fechaFin)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Avances registrados',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${etapa.avances.length}',
                          style: TextStyle(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (etapa.avances.isEmpty)
                    _InfoBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 42,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Todavía no hay avances registrados',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Agrega el primer avance de esta etapa.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(
                      etapa.avances.length,
                      (index) {
                        final avance = etapa.avances[index];

                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 14),
                          child: _InfoBox(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        avance.etiqueta,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                      ),
                                      onSelected: (opcion) {
                                        if (opcion == 'editar') {
                                          _editarAvance(index);
                                        } else if (
                                            opcion == 'eliminar') {
                                          _eliminarAvance(index);
                                        }
                                      },
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(
                                          value: 'editar',
                                          child: Text('Editar'),
                                        ),
                                        PopupMenuItem(
                                          value: 'eliminar',
                                          child: Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Wrap(
                                  spacing: 16,
                                  runSpacing: 8,
                                  children: [
                                    Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          size: 18,
                                          color: scheme.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(avance.autor),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 17,
                                          color: scheme.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(_fecha(avance.fecha)),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),
                                Text(
                                  avance.descripcion,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),

                                if (avance.archivos.isNotEmpty) ...[
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.attach_file,
                                        size: 18,
                                        color: scheme.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${avance.archivos.length} archivo(s) adjunto(s)',
                                        style: TextStyle(
                                          color: scheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _agregarAvance,
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Crear nuevo avance',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
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

  const _InfoBox({required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
