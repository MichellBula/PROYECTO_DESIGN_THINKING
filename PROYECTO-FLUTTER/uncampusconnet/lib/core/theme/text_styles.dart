import 'package:flutter/material.dart';

class AppTextStyles {
  //Titulos
  // Título de pantalla (ej: "Mis proyectos", "Solicitudes")
  static const TextStyle screenTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // Título de tarjeta (ej: "Nuevo diseño del juego!!")
  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Textos
  // Texto normal (ej: descripciones)
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
  );

  // Texto pequeño (ej: subtítulos, usuario, fecha)
  static const TextStyle smallText = TextStyle(
    fontSize: 12,
  );

  //Botones
  static const TextStyle buttonText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  //Navegación
  static const TextStyle navLabel = TextStyle(
    fontSize: 11,
  );

  //Home
  // Saludo (ej: "Hola, Juan!")
  static const TextStyle greeting = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  // Subtítulo (ej: "¿Qué deseas hacer hoy?")
  static const TextStyle subtitle = TextStyle(
    fontSize: 13,
  );

  // Título de sección (ej: "Eventos próximos:", "Publicaciones:")
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  // Nombre del autor (ej: "InnovaTech Team")
  static const TextStyle authorName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Texto secundario (ej: "@usuario - Hace 2h")
  static const TextStyle caption = TextStyle(
    fontSize: 12,
  );

  //Eventos
  // Fecha del evento (ej: "Mañana - 10:00 am")
  static const TextStyle eventDate = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
  );

  // Título del evento (ej: "Entrega avance")
  static const TextStyle eventTitle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  // Proyecto del evento (ej: "ElectroPesca")
  static const TextStyle eventProject = TextStyle(
    fontSize: 9,
  );

  // Etiqueta del evento (ej: "Avance", "Reunión")
  static const TextStyle eventTag = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.bold,
  );
}