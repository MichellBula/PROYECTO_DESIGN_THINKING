// Datos que consume la futura interfaz de solicitudes.
// Este tipo es distinto de la entidad de dominio `Solicitud`.
export interface SolicitudUI {
  nombre: string;
  usuario: string;
  proyecto: string;
  cargo: string;
  carrera: string;
  semestre: string;
  motivo: string;
  mensaje: string;
  idSolicitud?: number | null;
  idProyecto?: number | null;
  idUsuario?: number | null;
  idProyectoRol?: number | null;
  estado: string;
  fechaEnviada?: Date | null;
  fechaRespuesta?: Date | null;
}

export interface Mensaje {
  texto: string;
  isMine: boolean;
}

// Datos de muestra del Dart original; NO se consultan de Roble.
export const solicitudesRecibidasEjemplo: SolicitudUI[] = [
  {
    nombre: "Alejandra Torres Gutierrez",
    usuario: "@AlejandraTorres",
    proyecto: "ElectroPesca",
    cargo: "Programador",
    carrera: "Ingeniería de sistemas",
    semestre: "Cuarto semestre",
    motivo:
      "Estoy interesada porque este proyecto me parece muy interesante y quiero aportar mis conocimientos.",
    mensaje: "Te ha enviado una solicitud",
    estado: "pendiente",
  },
  {
    nombre: "Carlos Pérez",
    usuario: "@CarlosPerez",
    proyecto: "ElectroPesca",
    cargo: "Programador",
    carrera: "Ingeniería electrónica",
    semestre: "Sexto semestre",
    motivo: "Me interesa el proyecto porque tengo experiencia en Arduino.",
    mensaje: "Te ha enviado una solicitud",
    estado: "pendiente",
  },
  {
    nombre: "Andrés Rodríguez",
    usuario: "@AndresRodriguez",
    proyecto: "ElectroPesca",
    cargo: "Diseñador UX/UI",
    carrera: "Diseño gráfico",
    semestre: "Tercer semestre",
    motivo: "Quiero aportar en el diseño de la interfaz.",
    mensaje: "Te ha enviado una solicitud",
    estado: "pendiente",
  },
  {
    nombre: "María Fernández",
    usuario: "@MariaFernandez",
    proyecto: "ElectroPesca",
    cargo: "Analista de datos",
    carrera: "Ingeniería de sistemas",
    semestre: "Quinto semestre",
    motivo: "Tengo experiencia analizando datos y quiero aplicarla.",
    mensaje: "Te ha enviado una solicitud",
    estado: "pendiente",
  },
  {
    nombre: "Laura Gómez",
    usuario: "@LauraGomez",
    proyecto: "ServiGo",
    cargo: "Desarrollador frontend",
    carrera: "Ingeniería de software",
    semestre: "Séptimo semestre",
    motivo: "Me gusta el enfoque del proyecto.",
    mensaje: "Te ha enviado una solicitud",
    estado: "pendiente",
  },
  {
    nombre: "Sebastián Torres",
    usuario: "@SebastianTorres",
    proyecto: "MyDailyPet",
    cargo: "Diseñador UX/UI",
    carrera: "Diseño gráfico",
    semestre: "Cuarto semestre",
    motivo: "Me interesa el diseño de apps para mascotas.",
    mensaje: "Te ha enviado una solicitud",
    estado: "pendiente",
  },
];

export const solicitudesEnviadasEjemplo: SolicitudUI[] = [
  {
    nombre: "Yo",
    usuario: "@Yo",
    proyecto: "InnovaTech",
    cargo: "Desarrollador Flutter",
    carrera: "-",
    semestre: "-",
    motivo: "-",
    mensaje: "Solicitud enviada",
    estado: "pendiente",
  },
  {
    nombre: "Yo",
    usuario: "@Yo",
    proyecto: "StudyLink",
    cargo: "Diseñador UX/UI",
    carrera: "-",
    semestre: "-",
    motivo: "-",
    mensaje: "Solicitud enviada",
    estado: "pendiente",
  },
];
