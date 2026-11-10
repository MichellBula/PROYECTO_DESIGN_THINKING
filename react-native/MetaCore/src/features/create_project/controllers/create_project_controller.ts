import type { CreateProjectRequest } from "../domain/entities/create_project_request";
import type { CreateCompleteProject } from "../domain/usecases/create_complete_project";

// Clase independiente de React para poder probarla sin renderizar pantallas.
// Cuando se creen las pantallas, sus campos pueden vincularse a useState.
export class CreateProjectController {
  nombre = "";
  descripcion = "";
  lider = "";
  categoriaSeleccionada: string | null = null;
  cargando = false;

  constructor(
    private readonly createCompleteProject: Pick<CreateCompleteProject, "execute">,
    private readonly onError?: (message: string) => void
  ) {}

  async publicarProyecto(request: CreateProjectRequest): Promise<boolean> {
    if (this.cargando) {
      console.warn("[CREATE_PROJECT_CONTROLLER] Ya hay una publicación en progreso.");
      return false;
    }

    this.cargando = true;
    try {
      console.log("[CREATE_PROJECT_CONTROLLER] Publicando:", request.nombreProyecto);
      const resultado = await this.createCompleteProject.execute(request);
      console.log("[CREATE_PROJECT_CONTROLLER] Proyecto publicado:", resultado);
      return true;
    } catch (error) {
      console.error("[CREATE_PROJECT_CONTROLLER] No se pudo publicar:", error);
      this.onError?.(error instanceof Error ? error.message : String(error));
      return false;
    } finally {
      this.cargando = false;
    }
  }

  limpiarFormulario(): void {
    this.nombre = "";
    this.descripcion = "";
    this.lider = "";
    this.categoriaSeleccionada = null;
  }
}
