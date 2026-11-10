export interface CreateProjectRequest {
  nombreProyecto: string;
  descripcion: string;
  objetivo: string;
  categoria: string;
  tipoProyecto: string | null;
  roles: string[];
  cantidadesPorRol: Record<string, number>;
  habilidades: string[];
  requisitos: string;
  fechaInicio: Date;
  fechaCierre: Date;
  deseaDocente: boolean;
}
