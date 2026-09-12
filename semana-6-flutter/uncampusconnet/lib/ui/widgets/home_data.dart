import 'package:flutter/material.dart';

import 'package:uncampusconnet/ui/widgets/event_data.dart';

// ======================================================
// DATOS DE HOME
// ======================================================
//
// Este archivo contiene las listas de datos de prueba
// utilizadas en la pantalla principal.
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
        'Nos alegra compartir que ya nuestro juego tiene la interfaz gráfica preparada. Hemos trabajado en los detalles visuales y la experiencia de usuario.',
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
        'Nos alegra compartir que ya nuestro juego tiene funcionalidad nueva, junto con nuestro docente logramos terminarla.',
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
        'Hemos completado el prototipo de alta fidelidad para la nueva interfaz. Pronto comenzaremos las pruebas con usuarios.',
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
        'El nuevo sistema de autenticación ya está disponible en el entorno de producción. Todos los servicios están funcionando correctamente.',
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
        'Estamos preparando el lanzamiento de la nueva campaña para el próximo mes. Pronto compartiremos más detalles con el equipo.',
    likes: 7,
    comentarios: 3,
    imagen: 'assets/images/post5.png',
  ),

];