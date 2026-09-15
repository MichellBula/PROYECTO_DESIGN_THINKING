import 'package:flutter/material.dart';
import 'package:uncampusconnet/ui/widgets/event_data.dart';

// ======================================================
// DATOS DE HOME
// ======================================================
//
// Este archivo contiene las listas de datos de prueba
// utilizadas en la aplicación.
//
// Más adelante estas listas podrán ser reemplazadas
// por información proveniente de una API o base de datos.
// ======================================================


// ======================================================
// EVENTOS PRÓXIMOS
// ======================================================

const List<EventData> events = [
  EventData(
    day: 'Mañana',
    time: '10:00 am',
    title: 'Entrega avance',
    project: 'ElectroPesca',
    tag: 'Avance',
    icon: Icons.calendar_today_outlined,
    type: EventType.task,
  ),

  EventData(
    day: 'Jueves',
    time: '2:00 pm',
    title: 'Reunión equipo',
    project: 'ServiGo',
    tag: 'Reunión',
    icon: Icons.person_outline,
    type: EventType.meeting,
  ),

  EventData(
    day: 'Viernes',
    time: '11:00 am',
    title: 'Presentación',
    project: 'InnovaTech',
    tag: 'Presentación',
    icon: Icons.slideshow_outlined,
    type: EventType.task,
  ),

  EventData(
    day: 'Sábado',
    time: '3:00 pm',
    title: 'Revisión proyecto',
    project: 'Grupo Alfa',
    tag: 'Revisión',
    icon: Icons.folder_open_outlined,
    type: EventType.task,
  ),

  EventData(
    day: 'Lunes',
    time: '9:00 am',
    title: 'Reunión general',
    project: 'InnovaTech',
    tag: 'Reunión',
    icon: Icons.groups_outlined,
    type: EventType.meeting,
  ),
];


// ======================================================
// MODELO DE PUBLICACIÓN
// ======================================================

class Post {
  final String autor;
  final String usuario;
  final String tiempo;
  final String titulo;
  final String contenido;
  final int likes;
  final int comentarios;
  final String? imagen;
  final bool isLiked;

  const Post({
    required this.autor,
    required this.usuario,
    required this.tiempo,
    required this.titulo,
    required this.contenido,
    required this.likes,
    required this.comentarios,
    this.imagen,
    this.isLiked = false,
  });
}


// ======================================================
// PUBLICACIONES
// ======================================================

const List<Post> posts = [
  Post(
    autor: 'InnovaTech Team',
    usuario: '@InnovaTech_team - FeriaGamer',
    tiempo: 'Hace 2h',
    titulo: 'Nuevo diseño del juego!!',
    contenido:
        'Nos alegra compartir que ya nuestro juego tiene la interfaz gráfica preparada. '
        'Hemos trabajado en los detalles visuales y la experiencia de usuario.',
    likes: 12,
    comentarios: 2,
    imagen: 'assets/images/post1.png',
  ),

  Post(
    autor: 'ServiGo Team',
    usuario: '@ServiGo_Team - Feria Geoexpofisica',
    tiempo: 'Hace 5h',
    titulo: 'Funcionalidad nueva!!',
    contenido:
        'Nos alegra compartir que ya nuestro juego tiene funcionalidad nueva, '
        'junto con nuestro docente logramos terminarla.',
    likes: 12,
    comentarios: 2,
    imagen: 'assets/images/post2.png',
  ),

  Post(
    autor: 'Design Studio',
    usuario: '@design_studio - Proyecto UX',
    tiempo: 'Hace 4h',
    titulo: 'Prototipo finalizado',
    contenido:
        'Hemos completado el prototipo de alta fidelidad para la nueva interfaz. '
        'Pronto comenzaremos las pruebas con usuarios.',
    likes: 8,
    comentarios: 5,
    imagen: 'assets/images/post3.png',
  ),

  Post(
    autor: 'DevOps Team',
    usuario: '@devops_team - Infraestructura',
    tiempo: 'Hace 6h',
    titulo: 'Nuevo despliegue en producción',
    contenido:
        'El nuevo sistema de autenticación ya está disponible en el entorno de producción. '
        'Todos los servicios están funcionando correctamente.',
    likes: 5,
    comentarios: 1,
    imagen: 'assets/images/post4.png',
  ),

  Post(
    autor: 'Marketing Digital',
    usuario: '@marketing_digital - Campaña',
    tiempo: 'Hace 8h',
    titulo: 'Lanzamiento de nueva campaña',
    contenido:
        'Estamos preparando el lanzamiento de la nueva campaña para el próximo mes. '
        'Pronto compartiremos más detalles con el equipo.',
    likes: 7,
    comentarios: 3,
    imagen: 'assets/images/post5.png',
  ),
];


// ======================================================
// LISTAS DE CREACIÓN DE PROYECTOS
// ======================================================

const List<String> categories = [
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
  'Agricultura',
  'Ingeniería',
  'Finanzas',
  'Innovación',
  'Otro',
];

const List<String> roles = [
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
  'Consultor',
  'Emprendedor',
  'Técnico',
  'Asistente',
  'Otro',
];

const List<String> skills = [
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
  'Idiomas',
  'Otro',
];

const List<String> projectTypes = [
  'Geoexpofísica',
  'Servicios universitarios',
  'Proyecto de grado',
  'Investigación',
  'Feria Gamer',
  'Grupos estudiantiles',
  'Otro',
];


// ======================================================
// MODELO DE PROYECTOS DISPONIBLES
// ======================================================

class ProjectInfo {
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

  const ProjectInfo({
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


// ======================================================
// PROYECTOS DISPONIBLES - BUSCAR
// ======================================================

const List<ProjectInfo> availableProjects = [
  ProjectInfo(
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

  ProjectInfo(
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

  ProjectInfo(
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

  ProjectInfo(
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

  ProjectInfo(
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

  ProjectInfo(
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

  ProjectInfo(
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

  ProjectInfo(
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

// ======================================================
// MODELO DE PROYECTOS CREADOS
// ======================================================

class CreatedProjectInfo {
  final String nombreProyecto;
  final String descripcion;
  final String liderProyecto;
  final String categoria;

  final String objetivo;

  final List<String> roles;

  // Cantidad de personas requerida por cada rol.
  //  
  // Ejemplo:
  // {
  //   'Desarrollador': 2,
  //   'Diseñador UX/UI': 1
  // }
  final Map<String, int> cantidadesPorRol;

  final List<String> habilidades;
  final String requisitos;
  final String? tipoProyecto;

  final DateTime? fechaInicio;
  final DateTime? fechaCierre;

  final bool deseaDocente;

  const CreatedProjectInfo({
    required this.nombreProyecto,
    required this.descripcion,
    required this.liderProyecto,
    required this.categoria,
    required this.objetivo,
    required this.roles,
    required this.cantidadesPorRol,
    required this.habilidades,
    required this.requisitos,
    required this.tipoProyecto,
    required this.fechaInicio,
    required this.fechaCierre,
    required this.deseaDocente,
  });
}


// ======================================================
// LISTA DE PROYECTOS CREADOS
// ======================================================
//
// Esta lista almacena temporalmente los proyectos que
// el usuario publique.
//
// Más adelante podrá ser reemplazada por una base de datos.
// ======================================================

final List<CreatedProjectInfo> createdProjects = [];