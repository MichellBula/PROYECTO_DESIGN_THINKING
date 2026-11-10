
export type EventKind = 'avance' | 'reunion' | 'tarea';

export type HomeEvent = {
  id: string;
  title: string;
  dateLabel: string;
  projectName: string;
  kind: EventKind;
};

export type PostCategory =
  | 'videojuegos'
  | 'bienestar'
  | 'educacion';

export type PostComment = {
  id: string;
  author: string;
  text: string;
};

export type HomePost = {
  id: string;
  author: string;
  authorInfo: string;
  title: string;
  description: string;
  timeLabel: string;
  category: PostCategory;
  likes: number;
  likedByMe: boolean;
  comments: PostComment[];
};

export const demoEvents: HomeEvent[] = [
  {
    id: 'e1',
    title: 'Entrega avance',
    dateLabel: 'Mañana - 10:00 am',
    projectName: 'ElectroFishing',
    kind: 'avance',
  },
  {
    id: 'e2',
    title: 'Reunión equipo',
    dateLabel: 'Jueves - 2:00 pm',
    projectName: 'ServiGo',
    kind: 'reunion',
  },
  {
    id: 'e3',
    title: 'Entrega informe',
    dateLabel: 'Viernes - 1:30 pm',
    projectName: 'ServiGo',
    kind: 'tarea',
  },
  {
    id: 'e4',
    title: 'Revisión de prototipo',
    dateLabel: 'Lunes - 9:00 am',
    projectName: 'MyDailyPet',
    kind: 'reunion',
  },
  {
    id: 'e5',
    title: 'Presentación del proyecto',
    dateLabel: 'Martes - 11:00 am',
    projectName: 'ElectroFishing',
    kind: 'avance',
  },
];

// Publicaciones de demostración sin dependencias de imágenes.
export const demoPosts: HomePost[] = [
  {
    id: 'p1',
    author: 'InnovaTech Team',
    authorInfo: '@InnovaTech_team - FeriaGamer',
    title: 'Nuevo diseño del juego!!',
    description:
      'Nos alegra compartir que ya nuestro juego tiene la interfaz gráfica preparada...',
    timeLabel: 'Hace 5 h',
    category: 'videojuegos',
    likes: 12,
    likedByMe: false,
    comments: [
      { id: 'c11', author: 'María', text: '¡Qué buen avance!' },
      { id: 'c12', author: 'Juan', text: 'La interfaz se ve muy bien.' },
      { id: 'c13', author: 'Ana', text: 'Me gusta la propuesta.' },
    ],
  },
  {
    id: 'p2',
    author: 'Campus&Health',
    authorInfo: '@Campus&Health - bienestaryvidauninorte',
    title: 'Red de apoyo estudiantil',
    description:
      'Una comunidad para acompañarnos, compartir experiencias y generar redes de apoyo',
    timeLabel: 'Hace 15 h',
    category: 'bienestar',
    likes: 21,
    likedByMe: false,
    comments: [
      { id: 'c21', author: 'Sofía', text: 'Excelente iniciativa.' },
      { id: 'c22', author: 'Alejandra', text: '¿Cómo podemos participar?' },
      { id: 'c23', author: 'Luis', text: 'Muy necesaria para la comunidad.' },
      { id: 'c24', author: 'Valentina', text: 'Cuenten conmigo.' },
    ],
  },
  {
    id: 'p3',
    author: 'El Saber es Poder',
    authorInfo: '@elsaberespoder - Centro ECO',
    title: 'Biblioteca sin límites',
    description:
      'Espacios de estudio colaborativos, recursos digitales y actividades para bienestar estudiantil',
    timeLabel: 'Hace 18 h',
    category: 'educacion',
    likes: 12,
    likedByMe: false,
    comments: [
      { id: 'c31', author: 'Camilo', text: 'Quiero conocer los espacios.' },
      { id: 'c32', author: 'Andrea', text: '¡Buen proyecto!' },
    ],
  },
];
