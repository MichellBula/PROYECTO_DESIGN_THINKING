import 'package:uncampusconnet/core/database/roble_client.dart';

Future<void> main() async {
  print('========================================');
  print('SEED DE CATALOGOS');
  print('========================================');

  try {
    final roble = RobleClient.instance;

    // ======================================================
    // LOGIN PARA PODER INSERTAR LOS DATOS
    // ======================================================

    print('\n--- LOGIN ---');

    await roble.login(
      email: 'prueba@correo.com',
      password: 'Prueba123!',
    );

    print('Login exitoso.');

    // ======================================================
    // CATEGORIAS
    // ======================================================

    print('\n--- INSERTANDO CATEGORIAS ---');

    await _insertarCatalogo(
      roble: roble,
      tabla: 'categoria',
      campoId: 'id_categoria',
      campoNombre: 'nombre_categoria',
      valores: const [
        'Tecnología',
        'Educación',
        'Salud',
        'Ciencia e investigación',
        'Arte y diseño',
        'Cultura',
        'Medio ambiente',
        'Sostenibilidad',
        'Emprendimiento',
        'Negocios',
        'Marketing y publicidad',
        'Comunicación',
        'Ciencias sociales',
        'Comunidad y proyectos sociales',
        'Deporte',
        'Turismo',
        'Agricultura',
        'Ingeniería',
        'Finanzas',
        'Innovación',
      ],
    );

    // ======================================================
    // ROLES
    // ======================================================

    print('\n--- INSERTANDO ROLES ---');

    await _insertarCatalogo(
      roble: roble,
      tabla: 'rol',
      campoId: 'id_rol',
      campoNombre: 'nombre_rol',
      valores: const [
        'Líder de proyecto',
        'Coordinador',
        'Investigador',
        'Analista',
        'Desarrollador',
        'Diseñador',
        'Diseñador gráfico',
        'Diseñador UX/UI',
        'Marketing',
        'Comunicador',
        'Redactor',
        'Community Manager',
        'Fotógrafo',
        'Videógrafo',
        'Administrador',
        'Finanzas',
        'Logística',
        'Ventas',
        'Recursos humanos',
        'Docente',
        'Consultor',
        'Emprendedor',
        'Técnico',
        'Asistente',
      ],
    );

    // ======================================================
    // HABILIDADES
    // ======================================================

    print('\n--- INSERTANDO HABILIDADES ---');

    await _insertarCatalogo(
      roble: roble,
      tabla: 'habilidad',
      campoId: 'id_habilidad',
      campoNombre: 'nombre_habilidad',
      valores: const [
        'Liderazgo',
        'Trabajo en equipo',
        'Comunicación',
        'Organización',
        'Planificación',
        'Investigación',
        'Análisis de datos',
        'Resolución de problemas',
        'Creatividad',
        'Pensamiento crítico',
        'Innovación',
        'Gestión de proyectos',
        'Gestión del tiempo',
        'Negociación',
        'Atención al cliente',
        'Ventas',
        'Marketing',
        'Redacción',
        'Presentación',
        'Diseño gráfico',
        'Diseño UX/UI',
        'Fotografía',
        'Edición de video',
        'Programación',
        'Desarrollo web',
        'Desarrollo móvil',
        'Bases de datos',
        'Inteligencia artificial',
        'Contabilidad',
        'Finanzas',
        'Logística',
        'Docencia',
        'Inglés',
      ],
    );

    // ======================================================
    // TIPOS DE PROYECTO
    // ======================================================

    print('\n--- INSERTANDO TIPOS DE PROYECTO ---');

    await _insertarCatalogo(
      roble: roble,
      tabla: 'tipo_proyecto',
      campoId: 'id_tipo_proyecto',
      campoNombre: 'nombre_tipo_proyecto',
      valores: const [
        'Geoexpofísica',
        'Servicios universitarios',
        'Proyecto de grado',
        'Investigación',
        'Feria Gamer',
        'Grupos estudiantiles',
      ],
    );

    // ======================================================
    // LOGOUT
    // ======================================================

    print('\n--- LOGOUT ---');

    await roble.logout();

    print('Logout exitoso.');

    print('\n========================================');
    print('SEED FINALIZADO CORRECTAMENTE');
    print('========================================');
  } catch (e, stackTrace) {
    print('\n========================================');
    print('ERROR EN EL SEED');
    print('========================================');
    print(e);
    print('\nStackTrace:');
    print(stackTrace);
  }
}

Future<void> _insertarCatalogo({
  required dynamic roble,
  required String tabla,
  required String campoId,
  required String campoNombre,
  required List<String> valores,
}) async {
  for (int i = 0; i < valores.length; i++) {
    final id = i + 1;
    final nombre = valores[i];

    final resultado = await roble.create(
      tabla,
      {
        campoId: id,
        campoNombre: nombre,
      },
    );

    print(
      '$tabla → '
      '$campoId=$id → '
      '$campoNombre=$nombre',
    );

    print('Resultado: $resultado');
  }
}