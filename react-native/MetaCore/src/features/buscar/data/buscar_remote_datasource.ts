import type { RobleApiClient } from "roble-client";

import type { ProjectInfo } from "./project_info";
import type {
  ConvocatoriaReader,
  ProjectRolesReader,
  ProjectSkillsReader,
  RegistroRoble,
  UsuarioReader,
} from "./buscar_ports";

function toInt(value: unknown): number | null {
  if (value === null || value === undefined) return null;
  const text = String(value).trim();
  if (!/^[+-]?\d+$/.test(text)) return null;
  const number = Number(text);
  return Number.isSafeInteger(number) ? number : null;
}

function toText(value: unknown, fallback = ""): string {
  return value === null || value === undefined
    ? fallback
    : String(value);
}

function formatDate(date: Date): string {
  const day = String(date.getDate()).padStart(2, "0");
  const month = String(date.getMonth() + 1).padStart(2, "0");
  return day + "/" + month + "/" + date.getFullYear();
}

// El datasource no instancia dependencias de otras features: se inyectarán
// cuando se migren convocatoria, roles, habilidades y usuario.
export class BuscarRemoteDatasource {
  constructor(
    private readonly roble: RobleApiClient,
    private readonly convocatoriaDatasource: ConvocatoriaReader,
    private readonly rolesDatasource: ProjectRolesReader,
    private readonly skillsDatasource: ProjectSkillsReader,
    private readonly usuarioDatasource: UsuarioReader
  ) {}

  async getProjects(): Promise<ProjectInfo[]> {
    console.log("[BUSCAR] Iniciando carga de proyectos");

    // 1. Tablas principales y catálogos de Roble.
    const proyectos = (await this.roble.read("proyecto")) as RegistroRoble[];
    const categorias = (await this.roble.read("categoria")) as RegistroRoble[];
    const rolesCatalogo = (await this.roble.read("rol")) as RegistroRoble[];
    const habilidadesCatalogo =
      (await this.roble.read("habilidad")) as RegistroRoble[];

    console.log("[BUSCAR] Proyectos encontrados:", proyectos.length);
    console.log("[BUSCAR] Categorías:", categorias.length);
    console.log("[BUSCAR] Roles:", rolesCatalogo.length);
    console.log("[BUSCAR] Habilidades:", habilidadesCatalogo.length);

    // 2. Mapas por identificador.
    const categoriasPorId = new Map<number, string>();
    for (const categoria of categorias) {
      const id = toInt(categoria["id_categoria"]);
      const nombre = toText(categoria["nombre_categoria"]).trim();
      if (id !== null && nombre) categoriasPorId.set(id, nombre);
    }

    const rolesPorId = new Map<number, string>();
    for (const rol of rolesCatalogo) {
      const id = toInt(rol["id_rol"]);
      const nombre = toText(rol["nombre_rol"]).trim();
      if (id !== null && nombre) rolesPorId.set(id, nombre);
    }

    const habilidadesPorId = new Map<number, string>();
    for (const habilidad of habilidadesCatalogo) {
      const id = toInt(habilidad["id_habilidad"]);
      const nombre = toText(habilidad["nombre_habilidad"]).trim();
      if (id !== null && nombre) habilidadesPorId.set(id, nombre);
    }

    // 3. Construir ProjectInfo para cada proyecto.
    const resultado: ProjectInfo[] = [];

    for (const proyecto of proyectos) {
      try {
        const idProyecto = toInt(proyecto["id_proyecto"]);
        const idCreador = toInt(proyecto["id_creador"]);
        const idCategoria = toInt(proyecto["id_categoria"]);

        if (idProyecto === null) {
          console.warn(
            "[BUSCAR] Proyecto ignorado: id_proyecto inválido."
          );
          continue;
        }

        console.log("[BUSCAR] Procesando proyecto:", idProyecto);

        // Líder: tabla usuario.
        let leader = "Usuario";
        if (idCreador !== null) {
          const usuario =
            await this.usuarioDatasource.obtenerUsuarioPorId(idCreador);
          if (usuario) leader = usuario.nombreUsuario;
        }
        if (!leader.startsWith("@")) leader = "@" + leader;

        // Categoría: catálogo.
        const area =
          idCategoria === null
            ? "Sin categoría"
            : categoriasPorId.get(idCategoria) ?? "Sin categoría";

        // Fecha final de convocatoria.
        const convocatoria =
          await this.convocatoriaDatasource.getConvocatoriaByProject(
            idProyecto
          );

        let closingDate = "";
        if (convocatoria) {
          const rawFecha = toText(convocatoria["fecha_final"]);
          const fecha = new Date(rawFecha);
          if (rawFecha && !Number.isNaN(fecha.getTime())) {
            closingDate = formatDate(fecha);
          }
        }

        // Roles y cantidad de vacantes configuradas.
        const relacionesRoles =
          await this.rolesDatasource.getRolesByProject(idProyecto);
        const projectRoles: string[] = [];
        let vacancies = 0;

        for (const relacion of relacionesRoles) {
          const idRol = toInt(relacion["id_rol"]);
          vacancies += toInt(relacion["cantidad"]) ?? 0;
          if (idRol === null) continue;

          const nombreRol = rolesPorId.get(idRol);
          if (nombreRol) projectRoles.push(nombreRol);
        }

        // Habilidades, usadas como palabras clave para búsqueda.
        const relacionesHabilidades =
          await this.skillsDatasource.getSkillsByProject(idProyecto);
        const habilidades: string[] = [];

        for (const relacion of relacionesHabilidades) {
          const idHabilidad = toInt(relacion["id_habilidad"]);
          if (idHabilidad === null) continue;

          const nombreHabilidad = habilidadesPorId.get(idHabilidad);
          if (nombreHabilidad) habilidades.push(nombreHabilidad);
        }

        // Separación de requisitos por coma, punto y coma o salto de línea.
        const requisitos = toText(proyecto["requisitos"])
          .split(/[,;\n]/)
          .map((item) => item.trim())
          .filter((item) => item.length > 0);

        resultado.push({
          idProyecto,
          leader,
          name: toText(proyecto["nombre"], "Proyecto sin nombre"),
          members: toText(proyecto["num_integrantes"], "0"),
          vacancies: String(vacancies),
          closingDate,
          area,
          description: toText(proyecto["descripcion"]),
          requirements: requisitos,
          roles: projectRoles,
          keywords: habilidades.join(" "),
        });

        console.log("[BUSCAR] Proyecto agregado:", idProyecto);
      } catch (error) {
        // Igual que en Flutter: un proyecto fallido no detiene toda la lista.
        console.error("[BUSCAR] Error procesando proyecto:", error);
      }
    }

    console.log("[BUSCAR] Proyectos listos:", resultado.length);
    return resultado;
  }
}
