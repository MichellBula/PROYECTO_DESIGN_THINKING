// Modelos de consulta. Más adelante el repositorio Roble puede devolver estos tipos.
export type ProjectRole = { id: string; name: string; quantity: number };

export type DemoProject = {
  id: string;
  name: string;
  leader: string;
  leaderId: string;
  category: string;
  members: number;
  vacancies: number;
  closingDate: string; // ISO: YYYY-MM-DD
  description: string;
  requirements: string[];
  skills: string[];
  roles: ProjectRole[];
  icon: 'fish' | 'pets' | 'transport' | 'eco' | 'study';
  // Campos adicionales conservados al crear proyectos desde MetaCore.
  objective?: string;
  projectType?: string;
  startDate?: string;
  wantsAdvisor?: boolean;
};

export type RequestStatus = 'pendiente' | 'aceptada' | 'rechazada';

export type DemoApplication = {
  id: string;
  projectId: string;
  applicantId: string;
  applicantName: string;
  roleId: string;
  roleName: string;
  motivation: string;
  status: RequestStatus;
  createdAt: string;
};

export const demoUser = {
  id: 'demo-user',
  name: 'Alejandra Torres',
  email: 'alejandra@ejemplo.edu.co',
  career: 'Ingeniería de Sistemas',
  semester: '6',
};

export const demoProjects: DemoProject[] = [
  {
    id: 'electrofishing', name: 'ElectroFishing', leader: '@AlejandraProyectos',
    leaderId: 'u1', category: 'Innovación educacional', members: 5,
    vacancies: 3, closingDate: '2026-11-19', icon: 'fish',
    description: 'Proyecto de tecnología y electrónica aplicado a la exploración del agua. El equipo construye un prototipo de sensores y visualización de datos.',
    requirements: ['Conocimientos básicos de electrónica', 'Programación', 'Compromiso con el trabajo en equipo'],
    skills: ['Arduino', 'Programación', 'Circuitos'],
    roles: [{ id: 'ef-1', name: 'Programador', quantity: 2 }, { id: 'ef-2', name: 'Ingeniero electrónico', quantity: 1 }],
  },
  {
    id: 'mydailypet', name: 'MyDailyPet', leader: '@MaríaLopez',
    leaderId: 'u2', category: 'Medicina y bienestar animal', members: 4,
    vacancies: 1, closingDate: '2026-11-30', icon: 'pets',
    description: 'Aplicación para el cuidado y bienestar de las mascotas: actividades diarias, alimentación, salud, rutinas y recordatorios.',
    requirements: ['Interés en el desarrollo de aplicaciones', 'Conocimientos de UX/UI', 'Trabajo colaborativo'],
    skills: ['React Native', 'UX/UI', 'Salud animal'],
    roles: [{ id: 'md-1', name: 'Diseñador UX/UI', quantity: 1 }, { id: 'md-2', name: 'Desarrollador de aplicaciones', quantity: 1 }],
  },
  {
    id: 'servigo', name: 'ServiGo', leader: '@JuanPerez',
    leaderId: 'u3', category: 'Servicios universitarios', members: 10,
    vacancies: 2, closingDate: '2026-12-02', icon: 'transport',
    description: 'Plataforma para conectar estudiantes con servicios de tutoría, diseño, reparación de equipos y apoyo académico.',
    requirements: ['Conocimientos de desarrollo web o móvil', 'Bases de datos', 'Comunicación y trabajo en equipo'],
    skills: ['Backend', 'Frontend', 'Diseño UI'],
    roles: [{ id: 'sg-1', name: 'Desarrollador frontend', quantity: 1 }, { id: 'sg-2', name: 'Diseñador UI', quantity: 1 }],
  },
  {
    id: 'metacampus', name: 'MetaCampus Lab', leader: '@AlejandraTorres',
    leaderId: demoUser.id, category: 'Innovación educacional', members: 3,
    vacancies: 2, closingDate: '2026-12-15', icon: 'study',
    description: 'Laboratorio de iniciativas estudiantiles. Este proyecto de ejemplo pertenece al usuario para probar solicitudes recibidas.',
    requirements: ['Interés en investigación', 'Trabajo en equipo'],
    skills: ['Investigación', 'Innovación'],
    roles: [{ id: 'mc-1', name: 'Investigador', quantity: 2 }],
  },
  {
    id: 'ecocampus', name: 'EcoCampus', leader: '@CarlosMendez',
    leaderId: 'u4', category: 'Sostenibilidad', members: 6,
    vacancies: 0, closingDate: '2026-09-15', icon: 'eco',
    description: 'Iniciativa de reciclaje, reducción de residuos y sostenibilidad del campus. Se conserva como proyecto de inspiración.',
    requirements: ['Interés en sostenibilidad', 'Análisis de datos'],
    skills: ['Ecología', 'Reciclaje'],
    roles: [{ id: 'ec-1', name: 'Gestor ambiental', quantity: 0 }],
  },
  {
    id: 'studylink', name: 'StudyLink', leader: '@LauraGomez',
    leaderId: 'u5', category: 'Educación', members: 4,
    vacancies: 0, closingDate: '2026-10-20', icon: 'study',
    description: 'Aplicación para formar grupos de estudio por asignaturas e intereses. Una referencia para futuros proyectos.',
    requirements: ['Diseño de interfaces', 'Interés en educación'],
    skills: ['Aprendizaje', 'Diseño UX'],
    roles: [{ id: 'st-1', name: 'Diseñador UX/UI', quantity: 0 }],
  },
];

export function isProjectOpen(project: DemoProject): boolean {
  const closing = new Date(`${project.closingDate}T23:59:59`);
  return !Number.isNaN(closing.getTime()) && closing.getTime() >= Date.now() && project.vacancies > 0;
}

export function formatClosingDate(iso: string): string {
  const [year, month, day] = iso.split('-');
  return `${day}/${month}/${year}`;
}

export function matchesProject(project: DemoProject, term: string): boolean {
  const normalize = (value: string) => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
  const text = [project.name, project.leader, project.category, project.description,
    ...project.requirements, ...project.skills, ...project.roles.map(role => role.name)].join(' ');
  return normalize(text).includes(normalize(term.trim()));
}

export const initialReceivedRequests: DemoApplication[] = [{
  id: 'received-demo-1', projectId: 'metacampus', applicantId: 'demo-other-user',
  applicantName: 'Samuel Pacheco', roleId: 'mc-1', roleName: 'Investigador',
  motivation: 'Me interesa aportar al laboratorio de ideas y proyectos estudiantiles.',
  status: 'pendiente', createdAt: '2026-11-10',
}];
