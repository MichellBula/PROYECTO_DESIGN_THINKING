import 'package:flutter/material.dart';
import 'package:uncampusconnet/ui/pages/proyecto_disponible_page.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final TextEditingController searchController = TextEditingController();

  final List<String> activeFilters = [];

  static const List<_ProjectInfo> projects = [
    _ProjectInfo(
      leader: '@JuanPerez',
      name: 'Electropesca',
      members: '5',
      vacancies: '2',
      closingDate: '02/09/2026',
      area: 'Geoexpofísica',
      description:
          'Juego didáctico que busca enseñar de manera divertida '
          'la Ley de Ohm y las leyes de Kirchhoff mediante una '
          'experiencia interactiva basada en circuitos eléctricos.',
      requirements: [
        'Conocimientos básicos de Arduino',
        'Programación',
        'Electricidad y circuitos',
      ],
      roles: [
        'Programador',
        'Ingeniero electrónico',
      ],
      keywords:
          'innovación física electrónica electricidad circuitos '
          'arduino voltaje ley de ohm kirchhoff',
    ),

    _ProjectInfo(
      leader: '@MariaLopez',
      name: 'MyDailyPet',
      members: '4',
      vacancies: '2',
      closingDate: '30/09/2026',
      area: 'Tecnología y bienestar animal',
      description:
          'Aplicación móvil pensada para ayudar a los dueños de '
          'mascotas a organizar vacunas, citas veterinarias, '
          'alimentación y rutinas diarias desde un solo lugar.',
      requirements: [
        'Interés en desarrollo móvil',
        'Conocimientos básicos de UX/UI',
        'Trabajo en equipo',
      ],
      roles: [
        'Desarrollador Flutter',
        'Diseñador UX/UI',
      ],
      keywords:
          'mascotas animales veterinaria vacunas flutter aplicación '
          'móvil innovación tecnología',
    ),

    _ProjectInfo(
      leader: '@SofiaPerez',
      name: 'ServiGo',
      members: '10',
      vacancies: '3',
      closingDate: '06/09/2026',
      area: 'Servicios universitarios',
      description:
          'Plataforma que conecta estudiantes con personas que '
          'ofrecen servicios dentro de la comunidad universitaria, '
          'como tutorías, diseño, reparación de equipos y apoyo académico.',
      requirements: [
        'Desarrollo web o móvil',
        'Bases de datos',
        'Comunicación y trabajo colaborativo',
      ],
      roles: [
        'Desarrollador frontend',
        'Desarrollador backend',
        'Diseñador UI',
      ],
      keywords:
          'servicios universidad tutorías estudiantes desarrollo web '
          'móvil frontend backend innovación',
    ),

    _ProjectInfo(
      leader: '@CarlosMendez',
      name: 'EcoCampus',
      members: '6',
      vacancies: '2',
      closingDate: '15/09/2026',
      area: 'Sostenibilidad',
      description:
          'Proyecto enfocado en mejorar la sostenibilidad del campus '
          'mediante herramientas para reciclaje, reducción de residuos '
          'y seguimiento de iniciativas ambientales.',
      requirements: [
        'Interés en sostenibilidad',
        'Análisis de datos',
        'Desarrollo de soluciones digitales',
      ],
      roles: [
        'Analista de datos',
        'Desarrollador',
        'Gestor ambiental',
      ],
      keywords:
          'medio ambiente reciclaje residuos sostenibilidad ecología '
          'campus verde innovación',
    ),

    _ProjectInfo(
      leader: '@LauraGomez',
      name: 'StudyLink',
      members: '4',
      vacancies: '3',
      closingDate: '20/09/2026',
      area: 'Educación',
      description:
          'Aplicación diseñada para conectar estudiantes según '
          'asignaturas, horarios e intereses académicos, facilitando '
          'la creación de grupos de estudio.',
      requirements: [
        'Programación básica',
        'Diseño de interfaces',
        'Interés en educación',
      ],
      roles: [
        'Desarrollador móvil',
        'Diseñador UX/UI',
        'Gestor de comunidad',
      ],
      keywords:
          'estudio estudiantes educación grupos asignaturas '
          'universidad aplicación innovación',
    ),

    _ProjectInfo(
      leader: '@AndresRuiz',
      name: 'GreenTech',
      members: '7',
      vacancies: '1',
      closingDate: '25/09/2026',
      area: 'Tecnología sostenible',
      description:
          'Proyecto orientado al desarrollo de soluciones tecnológicas '
          'que ayuden a reducir el consumo energético y mejorar prácticas '
          'sostenibles dentro de la universidad.',
      requirements: [
        'Interés en tecnología sostenible',
        'Programación',
        'Conocimientos básicos de IoT',
      ],
      roles: [
        'Desarrollador IoT',
        'Programador',
        'Analista de sostenibilidad',
      ],
      keywords:
          'iot tecnología energía consumo energético sostenibilidad '
          'verde programación innovación',
    ),

    _ProjectInfo(
      leader: '@CamilaTorres',
      name: 'UniFood',
      members: '5',
      vacancies: '2',
      closingDate: '28/09/2026',
      area: 'Alimentación y tecnología',
      description:
          'Plataforma para consultar menús, realizar pedidos y conocer '
          'opciones de alimentación disponibles dentro del campus universitario.',
      requirements: [
        'Desarrollo de aplicaciones',
        'Diseño UX/UI',
        'Manejo básico de bases de datos',
      ],
      roles: [
        'Desarrollador Flutter',
        'Diseñador UX/UI',
        'Desarrollador backend',
      ],
      keywords:
          'comida alimentación menú pedidos restaurante universidad '
          'flutter aplicación innovación',
    ),

    _ProjectInfo(
      leader: '@MateoDiaz',
      name: 'CampusRide',
      members: '8',
      vacancies: '2',
      closingDate: '01/10/2026',
      area: 'Movilidad',
      description:
          'Sistema de movilidad compartida entre estudiantes que '
          'permite coordinar rutas, horarios y viajes hacia y desde '
          'la universidad.',
      requirements: [
        'Desarrollo móvil',
        'Manejo de mapas o geolocalización',
        'Bases de datos',
      ],
      roles: [
        'Desarrollador móvil',
        'Desarrollador backend',
        'Diseñador UX/UI',
      ],
      keywords:
          'transporte movilidad carro viajes rutas mapas '
          'geolocalización estudiantes innovación',
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<_ProjectInfo> get filteredProjects {
    if (activeFilters.isEmpty) {
      return projects;
    }

    return projects.where((project) {
      final String searchableText = [
        project.name,
        project.leader,
        project.area,
        project.description,
        project.keywords,
        ...project.requirements,
        ...project.roles,
      ].join(' ').toLowerCase();

      return activeFilters.every(
        (filter) => searchableText.contains(filter.toLowerCase()),
      );
    }).toList();
  }

  void _addFilter() {
    final String value = searchController.text.trim().toLowerCase();

    if (value.isEmpty) {
      return;
    }

    final bool alreadyExists = activeFilters.any(
      (filter) => filter.toLowerCase() == value,
    );

    if (!alreadyExists) {
      setState(() {
        activeFilters.add(value);
      });
    }

    searchController.clear();
    FocusScope.of(context).unfocus();
  }

  void _removeFilter(String filter) {
    setState(() {
      activeFilters.remove(filter);
    });
  }

  void _clearAllFilters() {
    setState(() {
      activeFilters.clear();
    });

    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor =
    isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

    final Color textColor =
        isDarkMode ? Colors.white : const Color(0xFF0A0A0A);

    final List<_ProjectInfo> visibleProjects = filteredProjects;

    // AHORA RETORNA SOLO EL CONTENIDO (sin Scaffold, sin HeaderBanner,
    // sin QuickAccessButtons), porque MainScaffold ya los coloca.
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 20,
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 52,
            child: Center(
              child: Text(
                '¡Encuentra proyectos disponibles!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),

          Divider(
            height: 1,
            color: isDarkMode
                ? const Color(0xFF333333)
                : const Color(0xFFD9D9D9),
          ),

          const SizedBox(height: 20),

            // BARRA DE BÚSQUEDA
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E2E2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(
                  color: Color(0xFF0A0A0A),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) {
                  _addFilter();
                },
                decoration: InputDecoration(
                  hintText: 'Buscar proyecto o categoría',
                  hintStyle: const TextStyle(
                    color: Color(0xFF6B6B6B),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    tooltip: 'Agregar filtro',
                    icon: const Icon(
                      Icons.search,
                      color: Color(0xFF500000),
                    ),
                    onPressed: _addFilter,
                  ),
                ),
              ),
            ),

            // FILTROS GUARDADOS
            if (activeFilters.isNotEmpty) ...[
              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...activeFilters.map(
                    (filter) => Container(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 6,
                        top: 7,
                        bottom: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9ACAC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filter,
                            style: const TextStyle(
                              color: Color(0xFF500000),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              _removeFilter(filter);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(3),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF500000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  TextButton.icon(
                    onPressed: _clearAllFilters,
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Color(0xFF931212),
                    ),
                    label: const Text(
                      'Limpiar',
                      style: TextStyle(
                        color: Color(0xFF931212),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 25),

            // CANTIDAD DE RESULTADOS
            Row(
              children: [
                Text(
                  'Grupos disponibles:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${visibleProjects.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF500000),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // SIN RESULTADOS
            if (visibleProjects.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 35,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 45,
                      color: Color(0xFF931212),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No encontramos proyectos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Prueba eliminando algún filtro.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDarkMode
                            ? Colors.white70
                            : const Color(0xFF6B6B6B),
                      ),
                    ),
                  ],
                ),
              ),

            // TARJETAS DE PROYECTOS
            ...visibleProjects.map(
              (project) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _GroupCard(
                  leader: project.leader,
                  name: project.name,
                  members: project.members,
                  vacancies: project.vacancies,
                  closingDate: project.closingDate,
                  area: project.area,
                  description: project.description,
                  requirements: project.requirements,
                  roles: project.roles,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MODELO DE PROYECTO
class _ProjectInfo {
  final String leader;
  final String name;
  final String members;
  final String vacancies;
  final String closingDate;
  final String area;
  final String description;
  final List<String> requirements;
  final List<String> roles;
  final String keywords;

  const _ProjectInfo({
    required this.leader,
    required this.name,
    required this.members,
    required this.vacancies,
    required this.closingDate,
    required this.area,
    required this.description,
    required this.requirements,
    required this.roles,
    required this.keywords,
  });
}

// TARJETA DE PROYECTO
class _GroupCard extends StatelessWidget {
  final String leader;
  final String name;
  final String members;
  final String vacancies;
  final String closingDate;
  final String area;
  final String description;
  final List<String> requirements;
  final List<String> roles;

  const _GroupCard({
    required this.leader,
    required this.name,
    required this.members,
    required this.vacancies,
    required this.closingDate,
    required this.area,
    required this.description,
    required this.requirements,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color cardColor =
      isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    final Color textColor =
      isDarkMode ? Colors.white : const Color(0xFF0A0A0A);

    final Color secondaryTextColor =
      isDarkMode ? Colors.white70 : const Color(0xFF6B6B6B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFF500000),
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoLine(
                  label: 'Líder: ',
                  value: leader,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                const SizedBox(height: 4),
                _InfoLine(
                  label: 'Nombre: ',
                  value: name,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                const SizedBox(height: 4),
                _InfoLine(
                  label: 'Integrantes: ',
                  value: members,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                const SizedBox(height: 4),
                _InfoLine(
                  label: 'Vacantes: ',
                  value: vacancies,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                const SizedBox(height: 4),
                _InfoLine(
                  label: 'Fecha cierre: ',
                  value: closingDate,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Ver proyecto',
            icon: Icon(
              Icons.more_vert,
              size: 28,
              color: textColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProyectoDisponiblePage(
                    leader: leader,
                    name: name,
                    members: members,
                    vacancies: vacancies,
                    closingDate: closingDate,
                    area: area,
                    description: description,
                    requirements: requirements,
                    roles: roles,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// LÍNEAS DE INFORMACIÓN
class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color secondaryTextColor;

  const _InfoLine({
    required this.label,
    required this.value,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}