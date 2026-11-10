import type { DemoApplication, DemoProject } from '@/features/projects/data/mock-projects';

// Reemplazar por el listado real de integrantes cuando Roble esté disponible.
export type ProjectMember = {
  id: string;
  name: string;
  role: string;
};

const seededMembers: Record<string, ProjectMember[]> = {
  metacampus: [
    { id: 'demo-user', name: 'Alejandra Torres', role: 'Líder' },
    { id: 'u-ana', name: 'Ana Rolón', role: 'Investigadora' },
    { id: 'u-juan', name: 'Juan Pérez', role: 'Programador' },
  ],
  mydailypet: [
    { id: 'u2', name: 'María López', role: 'Líder' },
    { id: 'demo-user', name: 'Alejandra Torres', role: 'Diseñadora UX/UI' },
    { id: 'u-ana', name: 'Ana Rolón', role: 'Desarrolladora' },
    { id: 'u-juan', name: 'Juan Pérez', role: 'Investigador' },
  ],
};

export function getProjectMembers(
  project: DemoProject,
  applications: DemoApplication[],
  currentUser: { id: string; name: string },
): ProjectMember[] {
  const members = [...(seededMembers[project.id] ?? [])];

  // Un proyecto creado localmente comienza con su líder.
  if (members.length === 0 && project.leaderId === currentUser.id) {
    members.push({ id: currentUser.id, name: currentUser.name, role: 'Líder' });
  }

  if (members.length === 0) {
    members.push({ id: project.leaderId, name: project.leader.replace(/^@/, ''), role: 'Líder' });
  }

  // Las solicitudes aprobadas incorporan integrantes en el entorno de prueba.
  for (const application of applications) {
    if (application.projectId === project.id && application.status === 'aceptada') {
      if (!members.some(member => member.id === application.applicantId)) {
        members.push({
          id: application.applicantId,
          name: application.applicantName,
          role: application.roleName,
        });
      }
    }
  }
  return members;
}

export function getDemoProgress(projectId: string): number {
  if (projectId === 'mydailypet') return 90;
  if (projectId === 'metacampus') return 10;
  return 0;
}

export function getDemoEvents(projectId: string) {
  return [
    { id: `${projectId}-event1`, title: 'Reunión del equipo', date: 'Jueves · 2:00 p. m.' },
    { id: `${projectId}-event2`, title: 'Revisión de avances', date: 'Viernes · 10:00 a. m.' },
  ];
}
