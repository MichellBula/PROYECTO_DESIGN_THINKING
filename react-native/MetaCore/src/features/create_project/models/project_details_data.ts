export interface ProjectDetailsData {
  objetivo: string;
  roles: string[];
  cantidadesPorRol: Record<string, number>;
  habilidades: string[];
  requisitos: string;
  tipoProyecto: string | null;
  fechaInicio: Date | null;
  fechaCierre: Date | null;
  deseaDocente: boolean;
}
