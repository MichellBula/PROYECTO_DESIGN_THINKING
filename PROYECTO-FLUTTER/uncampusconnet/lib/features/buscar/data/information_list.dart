import 'package:flutter/material.dart';
import 'package:uncampusconnet/features/home/data/event_data.dart';

// ======================================================
// DATOS DE HOME
// ======================================================
//
// Este archivo contiene las listas de datos de prueba
// utilizadas en la aplicaciÃ³n.
//
// MÃ¡s adelante estas listas podrÃ¡n ser reemplazadas
// por informaciÃ³n proveniente de una API o base de datos.
// ======================================================


// ======================================================
// EVENTOS PRÃ“XIMOS
// ======================================================

const List<EventData> events = [
  EventData(
    day: 'MaÃ±ana',
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
    title: 'ReuniÃ³n equipo',
    project: 'ServiGo',
    tag: 'ReuniÃ³n',
    icon: Icons.person_outline,
    type: EventType.meeting,
  ),

  EventData(
    day: 'Viernes',
    time: '11:00 am',
    title: 'PresentaciÃ³n',
    project: 'InnovaTech',
    tag: 'PresentaciÃ³n',
    icon: Icons.slideshow_outlined,
    type: EventType.task,
  ),

  EventData(
    day: 'SÃ¡bado',
    time: '3:00 pm',
    title: 'RevisiÃ³n proyecto',
    project: 'Grupo Alfa',
    tag: 'RevisiÃ³n',
    icon: Icons.folder_open_outlined,
    type: EventType.task,
  ),

  EventData(
    day: 'Lunes',
    time: '9:00 am',
    title: 'ReuniÃ³n general',
    project: 'InnovaTech',
    tag: 'ReuniÃ³n',
    icon: Icons.groups_outlined,
    type: EventType.meeting,
  ),
];


// ======================================================
// MODELO DE PUBLICACIÃ“N
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
    titulo: 'Nuevo diseÃ±o del juego!!',
    contenido:
        'Nos alegra compartir que ya nuestro juego tiene la interfaz grÃ¡fica preparada. '
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
    titulo: 'Nuevo despliegue en producciÃ³n',
    contenido:
        'El nuevo sistema de autenticaciÃ³n ya estÃ¡ disponible en el entorno de producciÃ³n. '
        'Todos los servicios estÃ¡n funcionando correctamente.',
    likes: 5,
    comentarios: 1,
    imagen: 'assets/images/post4.png',
  ),

  Post(
    autor: 'Marketing Digital',
    usuario: '@marketing_digital - CampaÃ±a',
    tiempo: 'Hace 8h',
    titulo: 'Lanzamiento de nueva campaÃ±a',
    contenido:
        'Estamos preparando el lanzamiento de la nueva campaÃ±a para el prÃ³ximo mes. '
        'Pronto compartiremos mÃ¡s detalles con el equipo.',
    likes: 7,
    comentarios: 3,
    imagen: 'assets/images/post5.png',
  ),
];


// ======================================================
// LISTAS DE CREACIÃ“N DE PROYECTOS
// ======================================================

const List<String> categories = [
  'TecnologÃ­a',
  'EducaciÃ³n',
  'Salud',
  'Ciencia e investigaciÃ³n',
  'Arte y diseÃ±o',
  'Cultura',
  'Medio ambiente',
  'Sostenibilidad',
  'Emprendimiento',
  'Negocios',
  'Marketing y publicidad',
  'ComunicaciÃ³n',
  'Ciencias sociales',
  'Comunidad y proyectos sociales',
  'Agricultura',
  'IngenierÃ­a',
  'Finanzas',
  'InnovaciÃ³n',
  'Otro',
];

const List<String> roles = [
  'Coordinador',
  'Investigador',
  'Analista',
  'Desarrollador',
  'DiseÃ±ador',
  'DiseÃ±ador grÃ¡fico',
  'DiseÃ±ador UX/UI',
  'Marketing',
  'Comunicador',
  'Redactor',
  'Community Manager',
  'FotÃ³grafo',
  'VideÃ³grafo',
  'Administrador',
  'Finanzas',
  'LogÃ­stica',
  'Ventas',
  'Recursos humanos',
  'Consultor',
  'Emprendedor',
  'TÃ©cnico',
  'Asistente',
  'Otro',
];

const List<String> skills = [
  'Liderazgo',
  'Trabajo en equipo',
  'ComunicaciÃ³n',
  'OrganizaciÃ³n',
  'PlanificaciÃ³n',
  'InvestigaciÃ³n',
  'AnÃ¡lisis de datos',
  'ResoluciÃ³n de problemas',
  'Creatividad',
  'Pensamiento crÃ­tico',
  'InnovaciÃ³n',
  'GestiÃ³n de proyectos',
  'GestiÃ³n del tiempo',
  'NegociaciÃ³n',
  'AtenciÃ³n al cliente',
  'Ventas',
  'Marketing',
  'RedacciÃ³n',
  'PresentaciÃ³n',
  'DiseÃ±o grÃ¡fico',
  'DiseÃ±o UX/UI',
  'FotografÃ­a',
  'EdiciÃ³n de video',
  'ProgramaciÃ³n',
  'Desarrollo web',
  'Desarrollo mÃ³vil',
  'Bases de datos',
  'Inteligencia artificial',
  'Contabilidad',
  'Finanzas',
  'LogÃ­stica',
  'Docencia',
  'Idiomas',
  'Otro',
];

const List<String> projectTypes = [
  'GeoexpofÃ­sica',
  'Servicios universitarios',
  'Proyecto de grado',
  'InvestigaciÃ³n',
  'Feria Gamer',
  'Grupos estudiantiles',
  'Otro',
];


// ======================================================
// MODELO DE PROYECTOS DISPONIBLES
// ======================================================

class ProjectInfo {
  final int? idProyecto;
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
    this.idProyecto,
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
    area: 'GeoexpofÃ­sica',
    description:
        'Juego didÃ¡ctico que busca enseÃ±ar de manera divertida '
        'la Ley de Ohm y las leyes de Kirchhoff mediante una '
        'experiencia interactiva basada en circuitos elÃ©ctricos.',
    requirements: [
      'Conocimientos bÃ¡sicos de Arduino',
      'ProgramaciÃ³n',
      'Electricidad y circuitos',
    ],
    roles: [
      'Programador',
      'Ingeniero electrÃ³nico',
    ],
    keywords:
        'innovaciÃ³n fÃ­sica electrÃ³nica electricidad circuitos '
        'arduino voltaje ley de ohm kirchhoff',
  ),

  ProjectInfo(
    leader: '@MariaLopez',
    name: 'MyDailyPet',
    members: '4',
    vacancies: '2',
    closingDate: '30/09/2026',
    area: 'TecnologÃ­a y bienestar animal',
    description:
        'AplicaciÃ³n mÃ³vil pensada para ayudar a los dueÃ±os de '
        'mascotas a organizar vacunas, citas veterinarias, '
        'alimentaciÃ³n y rutinas diarias desde un solo lugar.',
    requirements: [
      'InterÃ©s en desarrollo mÃ³vil',
      'Conocimientos bÃ¡sicos de UX/UI',
      'Trabajo en equipo',
    ],
    roles: [
      'Desarrollador Flutter',
      'DiseÃ±ador UX/UI',
    ],
    keywords:
        'mascotas animales veterinaria vacunas flutter aplicaciÃ³n '
        'mÃ³vil innovaciÃ³n tecnologÃ­a',
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
        'como tutorÃ­as, diseÃ±o, reparaciÃ³n de equipos y apoyo acadÃ©mico.',
    requirements: [
      'Desarrollo web o mÃ³vil',
      'Bases de datos',
      'ComunicaciÃ³n y trabajo colaborativo',
    ],
    roles: [
      'Desarrollador frontend',
      'Desarrollador backend',
      'DiseÃ±ador UI',
    ],
    keywords:
        'servicios universidad tutorÃ­as estudiantes desarrollo web '
        'mÃ³vil frontend backend innovaciÃ³n',
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
        'mediante herramientas para reciclaje, reducciÃ³n de residuos '
        'y seguimiento de iniciativas ambientales.',
    requirements: [
      'InterÃ©s en sostenibilidad',
      'AnÃ¡lisis de datos',
      'Desarrollo de soluciones digitales',
    ],
    roles: [
      'Analista de datos',
      'Desarrollador',
      'Gestor ambiental',
    ],
    keywords:
        'medio ambiente reciclaje residuos sostenibilidad ecologÃ­a '
        'campus verde innovaciÃ³n',
  ),

  ProjectInfo(
    leader: '@LauraGomez',
    name: 'StudyLink',
    members: '4',
    vacancies: '3',
    closingDate: '20/09/2026',
    area: 'EducaciÃ³n',
    description:
        'AplicaciÃ³n diseÃ±ada para conectar estudiantes segÃºn '
        'asignaturas, horarios e intereses acadÃ©micos, facilitando '
        'la creaciÃ³n de grupos de estudio.',
    requirements: [
      'ProgramaciÃ³n bÃ¡sica',
      'DiseÃ±o de interfaces',
      'InterÃ©s en educaciÃ³n',
    ],
    roles: [
      'Desarrollador mÃ³vil',
      'DiseÃ±ador UX/UI',
      'Gestor de comunidad',
    ],
    keywords:
        'estudio estudiantes educaciÃ³n grupos asignaturas '
        'universidad aplicaciÃ³n innovaciÃ³n',
  ),

  ProjectInfo(
    leader: '@AndresRuiz',
    name: 'GreenTech',
    members: '7',
    vacancies: '1',
    closingDate: '25/09/2026',
    area: 'TecnologÃ­a sostenible',
    description:
        'Proyecto orientado al desarrollo de soluciones tecnolÃ³gicas '
        'que ayuden a reducir el consumo energÃ©tico y mejorar prÃ¡cticas '
        'sostenibles dentro de la universidad.',
    requirements: [
      'InterÃ©s en tecnologÃ­a sostenible',
      'ProgramaciÃ³n',
      'Conocimientos bÃ¡sicos de IoT',
    ],
    roles: [
      'Desarrollador IoT',
      'Programador',
      'Analista de sostenibilidad',
    ],
    keywords:
        'iot tecnologÃ­a energÃ­a consumo energÃ©tico sostenibilidad '
        'verde programaciÃ³n innovaciÃ³n',
  ),

  ProjectInfo(
    leader: '@CamilaTorres',
    name: 'UniFood',
    members: '5',
    vacancies: '2',
    closingDate: '28/09/2026',
    area: 'AlimentaciÃ³n y tecnologÃ­a',
    description:
        'Plataforma para consultar menÃºs, realizar pedidos y conocer '
        'opciones de alimentaciÃ³n disponibles dentro del campus universitario.',
    requirements: [
      'Desarrollo de aplicaciones',
      'DiseÃ±o UX/UI',
      'Manejo bÃ¡sico de bases de datos',
    ],
    roles: [
      'Desarrollador Flutter',
      'DiseÃ±ador UX/UI',
      'Desarrollador backend',
    ],
    keywords:
        'comida alimentaciÃ³n menÃº pedidos restaurante universidad '
        'flutter aplicaciÃ³n innovaciÃ³n',
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
      'Desarrollo mÃ³vil',
      'Manejo de mapas o geolocalizaciÃ³n',
      'Bases de datos',
    ],
    roles: [
      'Desarrollador mÃ³vil',
      'Desarrollador backend',
      'DiseÃ±ador UX/UI',
    ],
    keywords:
        'transporte movilidad carro viajes rutas mapas '
        'geolocalizaciÃ³n estudiantes innovaciÃ³n',
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
  //   'DiseÃ±ador UX/UI': 1
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
// MÃ¡s adelante podrÃ¡ ser reemplazada por una base de datos.
// ======================================================

final List<CreatedProjectInfo> createdProjects = [];
