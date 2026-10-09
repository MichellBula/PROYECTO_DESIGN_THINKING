import 'package:uncampusconnet/core/database/roble_client.dart';

import 'data/datasources/avance_remote_datasource.dart';
import 'data/repositories/avance_repository_impl.dart';

import 'domain/entities/avance.dart';
import 'domain/usecases/create_avance.dart';
import 'domain/usecases/get_avance_by_id.dart';
import 'domain/usecases/get_avances_by_etapa.dart';

Future<void> main() async {
  print('========================================');
  print('TEST DE AVANCE');
  print('========================================');

  final roble = RobleClient.instance;

  try {
    // ======================================================
    // LOGIN
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
        'No existe un perfil de usuario registrado.',
      );
    }

    final idUsuario = int.parse(
      usuarios.first['id_usuario'].toString(),
    );

    print(
      'id_usuario autenticado: $idUsuario',
    );

    // ======================================================
    // BUSCAR PROYECTOS DEL USUARIO
    // ======================================================

    print('\n--- BUSCANDO PROYECTOS DEL USUARIO ---');

    final proyectosCreados = await roble.read(
      'proyecto',
      filters: {
        'id_creador': idUsuario,
      },
    );

    final relacionesIntegrante = await roble.read(
      'integrantes',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    final Set<int> idsProyectos = {};

    for (final proyecto in proyectosCreados) {
      final id = int.tryParse(
        proyecto['id_proyecto'].toString(),
      );

      if (id != null) {
        idsProyectos.add(id);
      }
    }

    for (final relacion in relacionesIntegrante) {
      final id = int.tryParse(
        relacion['id_proyecto'].toString(),
      );

      if (id != null) {
        idsProyectos.add(id);
      }
    }

    if (idsProyectos.isEmpty) {
      throw Exception(
        'El usuario no pertenece a ningún proyecto.',
      );
    }

    print(
      'Proyectos encontrados: ${idsProyectos.toList()}',
    );

    // ======================================================
    // BUSCAR UNA ETAPA CON MENOS DE CINCO AVANCES
    // ======================================================

    print(
      '\n--- BUSCANDO ETAPA DISPONIBLE ---',
    );

    final proyectosOrdenados =
        idsProyectos.toList()..sort();

    int? idEtapaSeleccionada;
    int numeroAvancesActual = 0;

    for (final idProyecto in proyectosOrdenados.reversed) {
      final etapas = await roble.read(
        'etapa_proyecto',
        filters: {
          'id_proyecto': idProyecto,
        },
      );

      final etapasOrdenadas = etapas
          .map(
            (item) => Map<String, dynamic>.from(
              item,
            ),
          )
          .toList();

      etapasOrdenadas.sort((a, b) {
        final ordenA = int.tryParse(
              a['orden'].toString(),
            ) ??
            0;

        final ordenB = int.tryParse(
              b['orden'].toString(),
            ) ??
            0;

        return ordenA.compareTo(ordenB);
      });

      for (final etapa in etapasOrdenadas) {
        final idEtapa = int.tryParse(
          etapa['id_etapa'].toString(),
        );

        if (idEtapa == null) {
          continue;
        }

        final avancesActuales = await roble.read(
          'avance',
          filters: {
            'id_etapa': idEtapa,
          },
        );

        if (avancesActuales.length < 5) {
          idEtapaSeleccionada = idEtapa;
          numeroAvancesActual = avancesActuales.length;

          print(
            'Proyecto: $idProyecto',
          );

          print(
            'Etapa: ${etapa['nombre_etapa']}',
          );

          print(
            'id_etapa: $idEtapa',
          );

          print(
            'Avances actuales: $numeroAvancesActual',
          );

          print(
            'Progreso actual: ${numeroAvancesActual * 20}%',
          );

          break;
        }
      }

      if (idEtapaSeleccionada != null) {
        break;
      }
    }

    if (idEtapaSeleccionada == null) {
      throw Exception(
        'No hay etapas disponibles con menos de cinco avances. '
        'Crea una etapa o utiliza una con espacio disponible.',
      );
    }

    // ======================================================
    // CREAR DEPENDENCIAS
    // ======================================================

    final datasource = AvanceRemoteDatasource(
      roble: roble,
    );

    final repository = AvanceRepositoryImpl(
      datasource: datasource,
    );

    final crearAvance = CreateAvance(
      repository: repository,
    );

    final obtenerAvancePorId = GetAvanceById(
      repository: repository,
    );

    final obtenerAvancesPorEtapa = GetAvancesByEtapa(
      repository: repository,
    );

    // ======================================================
    // CREAR AVANCE
    // ======================================================

    print('\n--- CREANDO AVANCE ---');

    final avance = Avance(
      idEtapa: idEtapaSeleccionada,
      comentario:
          'Avance de prueba registrado el ${DateTime.now().toIso8601String()}',
      fecha: DateTime.now(),
    );

    final resultado = await crearAvance(
      avance,
    );

    print('Avance creado correctamente.');
    print('Resultado: $resultado');

    final idAvance = int.parse(
      resultado['id_avance'].toString(),
    );

    print(
      'id_avance generado: $idAvance',
    );

    // ======================================================
    // LEER AVANCE POR ID
    // ======================================================

    print('\n--- LEYENDO AVANCE POR ID ---');

    final avanceLeido = await obtenerAvancePorId(
      idAvance,
    );

    if (avanceLeido == null) {
      throw Exception(
        'Se creó el avance pero no se pudo recuperar.',
      );
    }

    print('Avance encontrado.');
    print('----------------------------------------');

    print(
      'id_avance: ${avanceLeido['id_avance']}',
    );

    print(
      'id_etapa: ${avanceLeido['id_etapa']}',
    );

    print(
      'comentario: ${avanceLeido['comentario']}',
    );

    print(
      'fecha: ${avanceLeido['fecha']}',
    );

    print('----------------------------------------');

    // ======================================================
    // LEER TODOS LOS AVANCES DE LA ETAPA
    // ======================================================

    print('\n--- LEYENDO AVANCES DE LA ETAPA ---');

    final listaAvances = await obtenerAvancesPorEtapa(
      idEtapaSeleccionada,
    );

    final porcentaje =
        (listaAvances.length * 20).clamp(0, 100);

    print(
      'Cantidad de avances: ${listaAvances.length}',
    );

    for (final registro in listaAvances) {
      print(
        'id_avance=${registro['id_avance']} '
        '→ ${registro['comentario']}',
      );
    }

    print(
      'Progreso calculado: $porcentaje%',
    );

    if (listaAvances.length > 5) {
      throw Exception(
        'Error: la etapa superó el máximo permitido de cinco avances.',
      );
    }

    print(
      'Validación de límite: correcta.',
    );

    // ======================================================
    // LOGOUT
    // ======================================================

    print('\n--- LOGOUT ---');

    await roble.logout();

    print('Logout exitoso.');

    // ======================================================
    // RESULTADO FINAL
    // ======================================================

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