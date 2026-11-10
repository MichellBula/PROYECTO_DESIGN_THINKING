import { createContext, useContext, useMemo, useState, type PropsWithChildren } from 'react';
import {
  demoProjects, demoUser, initialReceivedRequests, isProjectOpen,
  type DemoApplication, type DemoProject, type RequestStatus,
} from '../data/mock-projects';

type SubmitResult = { ok: true } | { ok: false; message: string };

type ProjectsContextValue = {
  projects: DemoProject[];
  applications: DemoApplication[];
  currentUser: typeof demoUser;
  submitApplication: (projectId: string, roleId: string, motivation: string) => SubmitResult;
  answerApplication: (requestId: string, decision: 'aceptada' | 'rechazada') => void;
};

const ProjectsContext = createContext<ProjectsContextValue | null>(null);

export function DemoProjectsProvider({ children }: PropsWithChildren) {
  const [projects] = useState(demoProjects);
  const [applications, setApplications] = useState<DemoApplication[]>(initialReceivedRequests);

  function submitApplication(projectId: string, roleId: string, motivation: string): SubmitResult {
    const project = projects.find(item => item.id === projectId);
    if (!project) return { ok: false, message: 'No encontramos el proyecto.' };
    if (project.leaderId === demoUser.id) return { ok: false, message: 'No puedes postularte a tu propio proyecto.' };
    if (!isProjectOpen(project)) return { ok: false, message: 'La convocatoria está cerrada.' };
    if (applications.some(item => item.projectId === projectId && item.applicantId === demoUser.id)) {
      return { ok: false, message: 'Ya enviaste una solicitud para este proyecto.' };
    }
    const role = project.roles.find(item => item.id === roleId && item.quantity > 0);
    if (!role) return { ok: false, message: 'Selecciona un rol disponible.' };
    if (!motivation.trim() || motivation.trim().length > 500) {
      return { ok: false, message: 'El motivo debe tener entre 1 y 500 caracteres.' };
    }

    setApplications(current => [...current, {
      id: `demo-${Date.now()}`, projectId, applicantId: demoUser.id,
      applicantName: demoUser.name, roleId, roleName: role.name,
      motivation: motivation.trim(), status: 'pendiente' as RequestStatus,
      createdAt: new Date().toISOString().slice(0, 10),
    }]);
    return { ok: true };
  }

  function answerApplication(requestId: string, decision: 'aceptada' | 'rechazada') {
    setApplications(current => current.map(item => {
      const project = projects.find(p => p.id === item.projectId);
      if (item.id !== requestId || item.status !== 'pendiente' || project?.leaderId !== demoUser.id) {
        return item;
      }
      return { ...item, status: decision };
    }));
  }

  const value = useMemo(() => ({
    projects, applications, currentUser: demoUser,
    submitApplication, answerApplication,
  }), [projects, applications]);

  return <ProjectsContext.Provider value={value}>{children}</ProjectsContext.Provider>;
}

export function useDemoProjects() {
  const context = useContext(ProjectsContext);
  if (!context) throw new Error('DemoProjectsProvider debe envolver la navegación.');
  return context;
}
