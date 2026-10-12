import 'package:get/get.dart';

import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/solicitudes/data/solicitud_data.dart'
    as ui;
import 'package:uncampusconnet/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:uncampusconnet/features/solicitudes/data/repositories/solicitud_repository_impl.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/get_mis_solicitudes.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/get_solicitudes_pendientes.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/aceptar_solicitud.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/responder_solicitud.dart';
import 'package:uncampusconnet/features/integrantes/data/datasources/integrante_remote_datasource.dart';
import 'package:uncampusconnet/features/integrantes/data/repositories/integrante_repository_impl.dart';

class SolicitudesController extends GetxController {
  // 0 = Recibidas, 1 = Enviadas.
  final selectedTab = 0.obs;

  final searchQuery = ''.obs;

  final RxList<ui.Solicitud> solicitudesRecibidas = <ui.Solicitud>[].obs;

  final RxList<ui.Solicitud> solicitudesEnviadas = <ui.Solicitud>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final Rxn<int> procesandoSolicitudId = Rxn<int>();

  // Datasources existentes.
  final SolicitudRemoteDatasource _solicitudDatasource =
      SolicitudRemoteDatasource();

  final IntegranteRemoteDatasource _integranteDatasource =
      IntegranteRemoteDatasource();

  // Repositorios existentes.
  late final SolicitudRepositoryImpl _solicitudRepository =
      SolicitudRepositoryImpl(datasource: _solicitudDatasource);

  late final IntegranteRepositoryImpl _integranteRepository =
      IntegranteRepositoryImpl(datasource: _integranteDatasource);

  // Casos de uso existentes.
  late final GetMisSolicitudes _getMisSolicitudes = GetMisSolicitudes(
    repository: _solicitudRepository,
  );

  late final GetSolicitudesPendientes _getSolicitudesPendientes =
      GetSolicitudesPendientes(repository: _solicitudRepository);

  late final AceptarSolicitud _aceptarSolicitud = AceptarSolicitud(
    solicitudRepository: _solicitudRepository,
    integranteRepository: _integranteRepository,
  );

  late final ResponderSolicitud _responderSolicitud = ResponderSolicitud(
    repository: _solicitudRepository,
  );

  // Datos relacionados usados para mostrar información legible.
  List<Map<String, dynamic>> _usuarios = [];
  List<Map<String, dynamic>> _proyectos = [];
  List<Map<String, dynamic>> _proyectoRoles = [];
  List<Map<String, dynamic>> _roles = [];

  @override
  void onInit() {
    super.onInit();
    cargarSolicitudes();
  }

  // ==========================================================
  // CARGAR SOLICITUDES
  // ==========================================================

  Future<void> cargarSolicitudes() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Obtener el usuario de la sesión autenticada en Roble.
      final idUsuario = await _solicitudDatasource.getIdUsuarioAutenticado();

      // Leer solicitudes enviadas y recibidas usando los casos de uso.
      final enviadas = await _getMisSolicitudes(idUsuario);

      final recibidas = await _getSolicitudesPendientes(idUsuario);

      // Cargar una vez las tablas relacionadas.
      await _cargarDatosRelacionados();

      // Completar los datos que no están en la fila de solicitud.
      final enviadasCompletas = enviadas
          .map(_enriquecerSolicitud)
          .map(_mapearSolicitud)
          .toList();

      final recibidasCompletas = recibidas
          .map(_enriquecerSolicitud)
          .map(_mapearSolicitud)
          .toList();

      solicitudesEnviadas.assignAll(enviadasCompletas);
      solicitudesRecibidas.assignAll(recibidasCompletas);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '').trim();

      solicitudesEnviadas.clear();
      solicitudesRecibidas.clear();

      // El detalle del error queda disponible en errorMessage.
      print('[SOLICITUDES] Error cargando datos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================================
  // CONSULTAR TABLAS RELACIONADAS EN ROBLE
  // ==========================================================

  Future<void> _cargarDatosRelacionados() async {
    _usuarios = await _leerTabla('usuario');
    _proyectos = await _leerTabla('proyecto');
    _proyectoRoles = await _leerTabla('proyecto_roles');
    _roles = await _leerTabla('rol');
  }

  Future<List<Map<String, dynamic>>> _leerTabla(String nombreTabla) async {
    final resultado = await RobleClient.instance.read(nombreTabla);

    return resultado
        .map((fila) => Map<String, dynamic>.from(fila as Map))
        .toList();
  }

  // ==========================================================
  // RELACIONAR SOLICITUD, USUARIO, PROYECTO Y ROL
  // ==========================================================

  Map<String, dynamic> _enriquecerSolicitud(Map<String, dynamic> solicitud) {
    final datos = Map<String, dynamic>.from(solicitud);

    final usuario = _buscarPorId(_usuarios, 'id_usuario', datos['id_usuario']);

    final proyecto = _buscarPorId(
      _proyectos,
      'id_proyecto',
      datos['id_proyecto'],
    );

    final proyectoRol = _buscarPorId(
      _proyectoRoles,
      'id_proyecto_rol',
      datos['id_proyecto_rol'],
    );

    final rol = proyectoRol == null
        ? null
        : _buscarPorId(_roles, 'id_rol', proyectoRol['id_rol']);

    datos['nombre_usuario'] = _valorConAlternativa(
      datos['nombre_usuario'],
      _primerTexto(usuario, ['nombre_usuario', 'nombre_completo', 'nombre']),
      'Usuario no disponible',
    );

    datos['correo_institucional'] = _valorConAlternativa(
      datos['correo_institucional'],
      _primerTexto(usuario, ['correo_institucional', 'correo', 'email']),
      '',
    );

    datos['carrera'] = _valorConAlternativa(
      datos['carrera'],
      _primerTexto(usuario, ['carrera', 'programa_academico']),
      'No disponible',
    );

    datos['semestre_presentacion'] = _valorConAlternativa(
      datos['semestre_presentacion'],
      _primerTexto(usuario, ['semestre_presentacion', 'semestre']),
      'No disponible',
    );

    datos['nombre_proyecto'] = _valorConAlternativa(
      datos['nombre_proyecto'],
      _primerTexto(proyecto, ['nombre', 'nombre_proyecto']),
      'Proyecto no disponible',
    );

    datos['nombre_rol'] = _valorConAlternativa(
      datos['nombre_rol'],
      _primerTexto(rol, ['nombre_rol', 'nombre']),
      'Rol no disponible',
    );

    return datos;
  }

  Map<String, dynamic>? _buscarPorId(
    List<Map<String, dynamic>> filas,
    String campoId,
    dynamic idBuscado,
  ) {
    if (idBuscado == null) return null;

    final id = idBuscado.toString().trim();

    for (final fila in filas) {
      final valor = fila[campoId]?.toString().trim();

      if (valor == id) {
        return fila;
      }
    }

    return null;
  }

  String _primerTexto(Map<String, dynamic>? fila, List<String> campos) {
    if (fila == null) return '';

    for (final campo in campos) {
      final valor = fila[campo]?.toString().trim();

      if (valor != null && valor.isNotEmpty) {
        return valor;
      }
    }

    return '';
  }

  String _valorConAlternativa(
    dynamic principal,
    String alternativo,
    String valorPredeterminado,
  ) {
    final valor = principal?.toString().trim() ?? '';

    if (valor.isNotEmpty) return valor;
    if (alternativo.trim().isNotEmpty) return alternativo.trim();

    return valorPredeterminado;
  }

  // ==========================================================
  // CONVERTIR LOS DATOS AL MODELO DE INTERFAZ
  // ==========================================================

  ui.Solicitud _mapearSolicitud(Map<String, dynamic> datos) {
    final nombre = _texto(
      datos['nombre_usuario'],
      fallback: 'Usuario no disponible',
    );

    final correo = _texto(datos['correo_institucional'], fallback: '');

    final estado = _texto(
      datos['estado'],
      fallback: 'desconocido',
    ).toLowerCase();

    final mensaje = switch (estado) {
      'pendiente' => 'Solicitud pendiente',
      'aceptado' => 'Solicitud aceptada',
      'rechazado' => 'Solicitud rechazada',
      _ => 'Estado no disponible',
    };

    return ui.Solicitud(
      idSolicitud: _toInt(datos['id_solicitud']),
      idProyecto: _toInt(datos['id_proyecto']),
      idUsuario: _toInt(datos['id_usuario']),
      idProyectoRol: _toInt(datos['id_proyecto_rol']),
      nombre: nombre,
      usuario: correo.isNotEmpty
          ? correo
          : '@${nombre.replaceAll(RegExp(r'\s+'), '')}',
      proyecto: _texto(
        datos['nombre_proyecto'],
        fallback: 'Proyecto no disponible',
      ),
      cargo: _texto(datos['nombre_rol'], fallback: 'Rol no disponible'),
      carrera: _texto(datos['carrera']),
      semestre: _texto(datos['semestre_presentacion']),
      motivo: _texto(datos['comentario'], fallback: 'No se indicó un motivo.'),
      mensaje: mensaje,
      estado: estado,
      fechaEnviada: DateTime.tryParse(datos['fecha_enviada']?.toString() ?? ''),
      fechaRespuesta: DateTime.tryParse(
        datos['fecha_respuesta']?.toString() ?? '',
      ),
    );
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  String _texto(dynamic value, {String fallback = 'No disponible'}) {
    final texto = value?.toString().trim() ?? '';
    return texto.isEmpty ? fallback : texto;
  }

  // ==========================================================
  // ACEPTAR SOLICITUD
  // ==========================================================

  Future<bool> aceptarSolicitud(ui.Solicitud solicitud) async {
    final idSolicitud = solicitud.idSolicitud;

    if (idSolicitud == null) {
      Get.snackbar('Error', 'No se pudo identificar la solicitud.');
      return false;
    }

    if (solicitud.estado.toLowerCase() != 'pendiente') {
      Get.snackbar(
        'Solicitud no disponible',
        'Solo se pueden aceptar solicitudes pendientes.',
      );
      return false;
    }

    if (procesandoSolicitudId.value != null) {
      return false;
    }

    procesandoSolicitudId.value = idSolicitud;

    try {
      // Conserva la lógica existente para crear el integrante
      // y actualizar el estado mediante el caso de uso.
      await _aceptarSolicitud(idSolicitud);

      Get.snackbar(
        'Solicitud aceptada',
        '${solicitud.nombre} se ha añadido al proyecto.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await cargarSolicitudes();

      return true;
    } catch (e) {
      Get.snackbar(
        'No se pudo aceptar',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      procesandoSolicitudId.value = null;
    }
  }

  // ==========================================================
  // RECHAZAR SOLICITUD
  // ==========================================================

  Future<bool> rechazarSolicitud(ui.Solicitud solicitud) async {
    final idSolicitud = solicitud.idSolicitud;

    if (idSolicitud == null) {
      Get.snackbar('Error', 'No se pudo identificar la solicitud.');
      return false;
    }

    if (solicitud.estado.toLowerCase() != 'pendiente') {
      Get.snackbar(
        'Solicitud no disponible',
        'Solo se pueden rechazar solicitudes pendientes.',
      );
      return false;
    }

    if (procesandoSolicitudId.value != null) {
      return false;
    }

    procesandoSolicitudId.value = idSolicitud;

    try {
      await _responderSolicitud(
        idSolicitud: idSolicitud,
        nuevoEstado: 'rechazado',
      );

      Get.snackbar(
        'Solicitud rechazada',
        'La solicitud de ${solicitud.nombre} fue rechazada.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await cargarSolicitudes();

      return true;
    } catch (e) {
      Get.snackbar(
        'No se pudo rechazar',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      procesandoSolicitudId.value = null;
    }
  }

  // ==========================================================
  // BÚSQUEDA Y AGRUPACIÓN
  // ==========================================================

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  List<ui.Solicitud> get currentList {
    return selectedTab.value == 0
        ? solicitudesRecibidas.toList()
        : solicitudesEnviadas.toList();
  }

  List<ui.Solicitud> get filteredList {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return currentList;
    }

    return currentList.where((solicitud) {
      return solicitud.proyecto.toLowerCase().contains(query);
    }).toList();
  }

  Map<String, List<ui.Solicitud>> get groupedByProject {
    final Map<String, List<ui.Solicitud>> grouped = {};

    for (final solicitud in filteredList) {
      grouped.putIfAbsent(solicitud.proyecto, () => []);
      grouped[solicitud.proyecto]!.add(solicitud);
    }

    return grouped;
  }
}
