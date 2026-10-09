import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/features/etapa/data/datasource/etapa_remote_datasource.dart';

import 'data/repositories/etapa_repository_impl.dart';

import 'domain/entities/etapa.dart';
import 'domain/usecases/create_etapa.dart';
import 'domain/usecases/get_etapa_by_id.dart';
import 'domain/usecases/get_etapas_by_project.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE ETAPA_PROYECTO');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    // ======================================================
    // LOGIN COMO CREADOR
    // ======================================================

    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    // ======================================================
    // OBTENER USUARIO AUTENTICADO
    // ======================================================

    print('\n--- OBTENIENDO USUARIO AUTENTICADO ---');

    final authUser = await roble.currentUser();

    final idAutenticador =
        authUser['userId']?.toString();

    if (idAutenticador == null ||
        idAutenticador.isEmpty) {
      throw Exception(
        'No se pudo obtener el usuario autenticado.',
      );
    }

    final usuarios = await roble.read(
      'usuario',
      filters: {
        'id_autenticador': idAutenticador,
      },
    );

    if (usuarios.isEmpty) {
      throw Exception(
        'No existe perfil en la tabla usuario.',
      );
    }

    final idUsuario = int.parse(
      usuarios.first['id_usuario'].toString(),
    );

    print(
      'id_usuario autenticado: $idUsuario',
    );

    // ======================================================
    // BUSCAR PROYECTOS CREADOS POR EL USUARIO
    // ======================================================

    print('\n--- BUSCANDO PROYECTOS ---');

    final proyectos = await roble.read(
      'proyecto',
      filters: {
        'id_creador': idUsuario,
      },
    );

    if (proyectos.isEmpty) {
      throw Exception(
        'El usuario no tiene proyectos creados. '
        'Crea primero un proyecto para poder probar sus etapas.',
      );
    }

    final proyectosOrdenados =
        proyectos.map(
      (item) => Map<String, dynamic>.from(
        item,
      ),
    ).toList();

    proyectosOrdenados.sort((a, b) {
      final idA = int.tryParse(
            a['id_proyecto'].toString(),
          ) ??
          0;

      final idB = int.tryParse(
            b['id_proyecto'].toString(),
          ) ??
          0;

      return idB.compareTo(idA);
    });

    final proyecto = proyectosOrdenados.first;

    final idProyecto = int.parse(
      proyecto['id_proyecto'].toString(),
    );

    print(
      'Proyecto seleccionado: ${proyecto['nombre']}',
    );

    print(
      'id_proyecto: $idProyecto',
    );

    print(
      'id_creador: ${proyecto['id_creador']}',
    );

    // ======================================================
    // DEPENDENCIAS
    // ======================================================

    final datasource = EtapaRemoteDatasource(
      roble: roble,
    );

    final repository = EtapaRepositoryImpl(
      datasource: datasource,
    );

    final crearEtapa = CreateEtapa(
      repository: repository,
    );

    final obtenerEtapaPorId = GetEtapaById(
      repository: repository,
    );

    final obtenerEtapasDelProyecto = GetEtapasByProject(
      repository: repository,
    );

    // ======================================================
    // CALCULAR SIGUIENTE ORDEN
    // ======================================================

    print('\n--- CONSULTANDO ETAPAS EXISTENTES ---');

    final etapasExistentes =
        await obtenerEtapasDelProyecto(
      idProyecto,
    );

    print(
      'Etapas existentes: ${etapasExistentes.length}',
    );

    int mayorOrden = 0;

    for (final etapaExistente in etapasExistentes) {
      final orden = int.tryParse(
        etapaExistente['orden'].toString(),
      );

      if (orden != null && orden > mayorOrden) {
        mayorOrden = orden;
      }
    }

    final siguienteOrden = mayorOrden + 1;

    // ======================================================
    // CREAR ETAPA
    // ======================================================

    print('\n--- CREANDO ETAPA ---');

    final nombreEtapa =
        'Etapa de prueba ${DateTime.now().millisecondsSinceEpoch}';

    final etapa = Etapa(
      idProyecto: idProyecto,
      nombreEtapa: nombreEtapa,
      orden: siguienteOrden,
    );

    final resultado = await crearEtapa(
      etapa,
    );

    print('Etapa creada correctamente.');
    print('Resultado: $resultado');

    final idEtapa = int.parse(
      resultado['id_etapa'].toString(),
    );

    print(
      'id_etapa generado: $idEtapa',
    );

    // ======================================================
    // LEER ETAPA POR ID
    // ======================================================

    print('\n--- LEYENDO ETAPA POR ID ---');

    final etapaLeida = await obtenerEtapaPorId(
      idEtapa,
    );

    if (etapaLeida == null) {
      throw Exception(
        'Se creó la etapa pero no se pudo encontrar.',
      );
    }

    print('Etapa encontrada.');
    print('----------------------------------------');

    print(
      'id_etapa: ${etapaLeida['id_etapa']}',
    );

    print(
      'id_proyecto: ${etapaLeida['id_proyecto']}',
    );

    print(
      'nombre_etapa: ${etapaLeida['nombre_etapa']}',
    );

    print(
      'orden: ${etapaLeida['orden']}',
    );

    print('----------------------------------------');

    // ======================================================
    // LEER TODAS LAS ETAPAS DEL PROYECTO
    // ======================================================

    print('\n--- LEYENDO ETAPAS DEL PROYECTO ---');

    final etapasProyecto =
        await obtenerEtapasDelProyecto(
      idProyecto,
    );

    print(
      'Cantidad de etapas: ${etapasProyecto.length}',
    );

    for (final etapaProyecto in etapasProyecto) {
      print(
        'Orden ${etapaProyecto['orden']} '
        '→ ${etapaProyecto['nombre_etapa']} '
        '(id=${etapaProyecto['id_etapa']})',
      );
    }

    // ======================================================
    // LOGOUT
    // ======================================================

    print('\n--- LOGOUT ---');

    await roble.logout();

    print('Logout exitoso.');

    print('\n========================================');
    print('TEST FINALIZADO CORRECTAMENTE');
    print('========================================');
  } catch (e, stackTrace) {
    print('\n========================================');
    print('ERROR EN EL TEST');
    print('========================================');

    print(e);

    print('\nStackTrace:');
    print(stackTrace);

    try {
      await roble.logout();
    } catch (_) {}
  }
}