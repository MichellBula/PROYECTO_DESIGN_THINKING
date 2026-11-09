// Modelo empleado para mostrar proyectos en la búsqueda.
export interface ProjectInfo {
  idProyecto?: number;
  leader: string;
  name: string;
  members: string;
  vacancies: string;
  closingDate: string;
  area: string;
  description: string;
  requirements: string[];
  roles: string[];
  keywords: string;
}
