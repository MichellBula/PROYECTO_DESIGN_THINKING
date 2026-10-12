import 'package:get/get.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/evento_data.dart';
import 'package:uncampusconnet/features/mis_proyectos/data/datasources/evento_datasource.dart';

class EventoController extends GetxController {
  final _datasource = EventoDatasource();

  final cargando = false.obs;
  final eventos = <EventoData>[].obs;
  final esMensual = true.obs;
  final fechaActual = DateTime.now().obs;

  int? _idProyecto;

  Future<void> cargarEventos(int idProyecto) async {
    _idProyecto = idProyecto;
    cargando.value = true;

    try {
      eventos.value = await _datasource.getEventosByProject(idProyecto);
    } catch (e) {
      eventos.clear();
      print('[EVENTO] Error cargando: $e');
    }

    cargando.value = false;
  }

  List<EventoData> eventosDelDia(DateTime dia) {
    return eventos.where((e) {
      return e.fechaInicio.year == dia.year &&
          e.fechaInicio.month == dia.month &&
          e.fechaInicio.day == dia.day;
    }).toList();
  }

  Future<bool> crearEvento({
    required String nombre,
    required String tipo,
    required String descripcion,
    required DateTime inicio,
    required DateTime fin,
  }) async {
    if (_idProyecto == null) return false;

    try {
      await _datasource.createEvento(
        EventoData(
          idEvento: 0,
          idProyecto: _idProyecto!,
          nombre: nombre,
          tipoEvento: tipo,
          descripcion: descripcion,
          fechaInicio: inicio,
          fechaFinal: fin,
        ),
      );

      await cargarEventos(_idProyecto!);
      return true;
    } catch (e) {
      print('[EVENTO] Error creando: $e');
      return false;
    }
  }

  void cambiarVista(bool mensual) => esMensual.value = mensual;

  void irHoy() => fechaActual.value = DateTime.now();

  void anterior() {
    final f = fechaActual.value;
    fechaActual.value = esMensual.value
        ? DateTime(f.year, f.month - 1, 1)
        : f.subtract(const Duration(days: 7));
  }

  void siguiente() {
    final f = fechaActual.value;
    fechaActual.value = esMensual.value
        ? DateTime(f.year, f.month + 1, 1)
        : f.add(const Duration(days: 7));
  }
}