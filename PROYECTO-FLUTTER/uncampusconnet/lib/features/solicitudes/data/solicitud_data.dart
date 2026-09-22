class Solicitud {
  final String nombre;
  final String usuario;      // ← NUEVO
  final String proyecto;
  final String cargo;
  final String carrera;      // ← NUEVO
  final String semestre;     // ← NUEVO
  final String motivo;       // ← NUEVO
  final String mensaje;

  const Solicitud({
    required this.nombre,
    required this.usuario,
    required this.proyecto,
    required this.cargo,
    required this.carrera,
    required this.semestre,
    required this.motivo,
    required this.mensaje,
  });
}

//Recibidas
const List<Solicitud> solicitudesRecibidas = [
  Solicitud(
    nombre: 'Alejandra Torres Gutierrez',
    usuario: '@AlejandraTorres',
    proyecto: 'ElectroPesca',
    cargo: 'Programador',
    carrera: 'Ingeniería de sistemas',
    semestre: 'Cuarto semestre',
    motivo: 'Estoy interesada porque este proyecto me parece muy interesante y quiero aportar mis conocimientos.',
    mensaje: 'Te ha enviado una solicitud',
  ),
  Solicitud(
    nombre: 'Carlos Pérez',
    usuario: '@CarlosPerez',
    proyecto: 'ElectroPesca',
    cargo: 'Programador',
    carrera: 'Ingeniería electrónica',
    semestre: 'Sexto semestre',
    motivo: 'Me interesa el proyecto porque tengo experiencia en Arduino.',
    mensaje: 'Te ha enviado una solicitud',
  ),
  Solicitud(
    nombre: 'Andrés Rodríguez',
    usuario: '@AndresRodriguez',
    proyecto: 'ElectroPesca',
    cargo: 'Diseñador UX/UI',
    carrera: 'Diseño gráfico',
    semestre: 'Tercer semestre',
    motivo: 'Quiero aportar en el diseño de la interfaz.',
    mensaje: 'Te ha enviado una solicitud',
  ),
  Solicitud(
    nombre: 'María Fernández',
    usuario: '@MariaFernandez',
    proyecto: 'ElectroPesca',
    cargo: 'Analista de datos',
    carrera: 'Ingeniería de sistemas',
    semestre: 'Quinto semestre',
    motivo: 'Tengo experiencia analizando datos y quiero aplicarla.',
    mensaje: 'Te ha enviado una solicitud',
  ),
  Solicitud(
    nombre: 'Laura Gómez',
    usuario: '@LauraGomez',
    proyecto: 'ServiGo',
    cargo: 'Desarrollador frontend',
    carrera: 'Ingeniería de software',
    semestre: 'Séptimo semestre',
    motivo: 'Me gusta el enfoque del proyecto.',
    mensaje: 'Te ha enviado una solicitud',
  ),
  Solicitud(
    nombre: 'Sebastián Torres',
    usuario: '@SebastianTorres',
    proyecto: 'MyDailyPet',
    cargo: 'Diseñador UX/UI',
    carrera: 'Diseño gráfico',
    semestre: 'Cuarto semestre',
    motivo: 'Me interesa el diseño de apps para mascotas.',
    mensaje: 'Te ha enviado una solicitud',
  ),
];

//Enviadas

const List<Solicitud> solicitudesEnviadas = [
  Solicitud(
    nombre: 'Yo',
    usuario: '@Yo',
    proyecto: 'InnovaTech',
    cargo: 'Desarrollador Flutter',
    carrera: '-',
    semestre: '-',
    motivo: '-',
    mensaje: 'Solicitud enviada',
  ),
  Solicitud(
    nombre: 'Yo',
    usuario: '@Yo',
    proyecto: 'StudyLink',
    cargo: 'Diseñador UX/UI',
    carrera: '-',
    semestre: '-',
    motivo: '-',
    mensaje: 'Solicitud enviada',
  ),
];

//chat
class Mensaje {
  final String texto;
  final bool isMine;

  const Mensaje({
    required this.texto,
    required this.isMine,
  });
}