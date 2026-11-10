import { createContext, useContext, useEffect, useMemo, useState, type PropsWithChildren } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {
  demoProjects, demoUser, initialReceivedRequests, isProjectOpen,
  type DemoApplication, type DemoProject, type RequestStatus,
} from '../data/mock-projects';
import {
  validateCreateProject, type CreateProjectInput, type CreateProjectResult,
} from '@/features/create-project/data/create-project-model';

type SubmitResult = { ok: true } | { ok: false; message: string };

type ProjectsContextValue = {
  projects: DemoProject[];
  applications: DemoApplication[];
  currentUser: typeof demoUser;
  createProject: (input: CreateProjectInput) => CreateProjectResult;
  submitApplication: (projectId: string, roleId: string, motivation: string) => SubmitResult;
  answerApplication: (requestId: string, decision: 'aceptada' | 'rechazada') => void;
};

const ProjectsContext = createContext<ProjectsContextValue | null>(null);
const LOCAL_PROJECTS_KEY = '@metacore/demo-created-projects';

export function DemoProjectsProvider({ children }: PropsWithChildren) {
  const [projects, setProjects] = useState<DemoProject[]>(demoProjects);
  const [applications, setApplications] = useState<DemoApplication[]>(initialReceivedRequests);
  const [storageLoaded, setStorageLoaded] = useState(false);

  // Persistencia temporal local; cambiar por el repositorio Roble más adelante.
  useEffect(() => {
    let mounted = true;
    async function loadLocalProjects() {
      try {
        const raw = await AsyncStorage.getItem(LOCAL_PROJECTS_KEY);
        if (!raw || !mounted) return;
        const parsed: unknown = JSON.parse(raw);
        if (!Array.isArray(parsed)) return;
        const saved = parsed.filter((item): item is DemoProject =>
          typeof item === 'object' && item !== null &&
          'id' in item && typeof item.id === 'string' &&
          item.id.startsWith('local-project-') &&
          'name' in item && typeof item.name === 'string' &&
          'roles' in item && Array.isArray(item.roles),
        );
        setProjects(current => {
          const loadedIds = new Set(saved.map(item => item.id));
          return [...saved, ...current.filter(item => !loadedIds.has(item.id))];
        });
      } catch (error) {
        console.warn('No se pudieron leer los proyectos locales:', error);
      } finally {
        if (mounted) setStorageLoaded(true);
      }
    }
    void loadLocalProjects();
    return () => { mounted = false; };
  }, []);

  useEffect(() => {
    if (!storageLoaded) return;
    const created = projects.filter(item => item.id.startsWith('local-project-'));
    void AsyncStorage.setItem(LOCAL_PROJECTS_KEY, JSON.stringify(created))
      .catch(error => console.warn('No se pudieron guardar los proyectos locales:', error));
  }, [projects, storageLoaded]);

  // La misma entrada podrá enviarse después a un repositorio Roble.
  function createProject(input: CreateProjectInput): CreateProjectResult {
    const error = validateCreateProject(input);
    if (error) return { ok: false, message: error };

    const id = `local-project-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`;
    const roles = Object.entries(input.roleQuantities).map(([name, quantity], index) => ({
      id: `${id}-role-${index + 1}`, name, quantity,
    }));
    const requirements = input.requirements.split(/[,;\n]/).map(item => item.trim()).filter(Boolean);
    const vacancies = roles.reduce((sum, role) => sum + role.quantity, 0);

    const project: DemoProject = {
      id,
      name: input.name.trim(),
      leader: `@${demoUser.name.replace(/\s+/g, '')}`,
      leaderId: demoUser.id,
      category: input.category,
      members: 1,
      vacancies,
      closingDate: input.closingDate!,
      description: input.description.trim(),
      requirements,
      skills: [...input.skills],
      roles,
      icon: 'study', // Icono temporal hasta permitir imágenes del usuario.
      objective: input.objective.trim(),
      projectType: input.projectType,
      startDate: input.startDate!,
      wantsAdvisor: input.wantsAdvisor,
    };

    setProjects(current => [project, ...current]);
    return { ok: true, projectId: id };
  }

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
    createProject, submitApplication, answerApplication,
  }), [projects, applications]);

  return <ProjectsContext.Provider value={value}>{children}</ProjectsContext.Provider>;
}

export function useDemoProjects() {
  const context = useContext(ProjectsContext);
  if (!context) throw new Error('DemoProjectsProvider debe envolver la navegación.');
  return context;
}
