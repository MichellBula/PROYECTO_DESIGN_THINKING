import type { RobleApiClient } from "roble-client";
import type { CreateProjectRequest } from "../../domain/entities/create_project_request";
import type { RegistroRoble } from "../../domain/entities/types";
import { parseId } from "../../domain/entities/types";
import type { CompleteProjectCreator } from "../../domain/usecases/create_complete_project";
import { ConvocatoriaModel } from "../../models/convocatoria_model";
import { ProjectModel } from "../../models/project_model";
import { ProjectRoleModel } from "../../models/project_role_model";
import { ProjectSkillModel } from "../../models/project_skill_model";
import { ConvocatoriaRemoteDatasource } from "./convocatoria_remote_datasource";
import type { IntegranteCreator, UsuarioStatsUpdater } from "./create_project_ports";
import { ProjectRemoteDatasource } from "./project_remote_datasource";
import { ProjectRolesRemoteDatasource } from "./project_roles_remote_datasource";
import { ProjectSkillsRemoteDatasource } from "./project_skills_remote_datasource";
import { firstRow } from "./roble_utils";

export class CreateProjectCompleteRemoteDatasource implements CompleteProjectCreator {
  private readonly projectDatasource: ProjectRemoteDatasource;
  private readonly rolesDatasource: ProjectRolesRemoteDatasource;
  private readonly skillsDatasource: ProjectSkillsRemoteDatasource;
  private readonly convocatoriaDatasource: ConvocatoriaRemoteDatasource;

  constructor(
    private readonly roble: RobleApiClient,
    private readonly integranteDatasource: IntegranteCreator,
    statsService: UsuarioStatsUpdater,
    dependencies: {
      projectDatasource?: ProjectRemoteDatasource;
      rolesDatasource?: ProjectRolesRemoteDatasource;
      skillsDatasource?: ProjectSkillsRemoteDatasource;
      convocatoriaDatasource?: ConvocatoriaRemoteDatasource;
    } = {}
  ) {
    this.projectDatasource = dependencies.projectDatasource ?? new ProjectRemoteDatasource(roble, statsService);
    this.rolesDatasource = dependencies.rolesDatasource ?? new ProjectRolesRemoteDatasource(roble);
    this.skillsDatasource = dependencies.skillsDatasource ?? new ProjectSkillsRemoteDatasource(roble);
    this.convocatoriaDatasource = dependencies.convocatoriaDatasource ?? new ConvocatoriaRemoteDatasource(roble);
  }

  private async obtenerIdUsuarioAutenticado(): Promise<number> {
    const authUser = await this.roble.currentUser();
    const userId = authUser.userId;
    if (!userId) throw new Error("No fue posible obtener el usuario autenticado.");
    const perfil = await firstRow(this.roble, "usuario", { id_autenticador: userId });
    if (!perfil) throw new Error("La cuenta autenticada no tiene un perfil registrado.");
    return parseId(perfil.id_usuario, "id_usuario");
  }

  private async obtenerIdPorNombre(params: {
    tabla: string; campoId: string; valor: string; camposNombre: string[];
  }): Promise<number> {
    const registros = await this.roble.read(params.tabla);
    const buscado = params.valor.trim().toLowerCase();
    for (const row of registros) {
      if (params.camposNombre.some(campo => String(row[campo] ?? "").trim().toLowerCase() === buscado)) {
        return parseId(row[params.campoId], params.campoId);
      }
    }
    throw new Error(`No se encontró "${params.valor}" en la tabla ${params.tabla}.`);
  }

  private inicioDelDia(date: Date): Date {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate());
  }
  private finalDelDia(date: Date): Date {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 23, 59, 59);
  }

  private async agregarCreadorComoLider(idProyecto: number, idCreador: number): Promise<void> {
    const existe = await firstRow(this.roble, "integrantes", {
      id_usuario: idCreador, id_proyecto: idProyecto,
    });
    if (existe) return;
    await this.integranteDatasource.createIntegranteSimple({
      idUsuario: idCreador, idProyecto, idRol: 1,
    });
  }

  async crearProyectoCompleto(request: CreateProjectRequest): Promise<RegistroRoble> {
    if (!request.nombreProyecto.trim()) throw new Error("El nombre del proyecto no puede estar vacío.");
    if (!request.descripcion.trim()) throw new Error("La descripción no puede estar vacía.");
    if (!request.objetivo.trim()) throw new Error("El objetivo general no puede estar vacío.");
    if (!request.requisitos.trim()) throw new Error("Los requisitos no pueden estar vacíos.");
    if (request.roles.length === 0) throw new Error("Debe existir al menos un rol.");
    if (request.habilidades.length === 0) throw new Error("Debe existir al menos una habilidad.");
    if (!request.tipoProyecto?.trim()) throw new Error("Debe seleccionarse el tipo de proyecto.");
    if (request.fechaCierre < request.fechaInicio) {
      throw new Error("La fecha de cierre no puede ser anterior a la fecha de inicio.");
    }
    if (Math.floor((request.fechaCierre.getTime() - request.fechaInicio.getTime()) / 86400000) < 7) {
      throw new Error("La fecha de cierre debe ser mínimo 7 días después de la fecha de inicio.");
    }

    // Resolver las dependencias antes de crear la primera fila, para reducir
    // el riesgo de dejar un proyecto parcial por errores de catálogo.
    const idCreador = await this.obtenerIdUsuarioAutenticado();
    const idCategoria = await this.obtenerIdPorNombre({
      tabla: "categoria", campoId: "id_categoria", valor: request.categoria,
      camposNombre: ["nombre_categoria", "categoria", "nombre"],
    });
    const idTipoProyecto = await this.obtenerIdPorNombre({
      tabla: "tipo_proyecto", campoId: "id_tipo_proyecto", valor: request.tipoProyecto,
      camposNombre: ["nombre_tipo_proyecto", "tipo_proyecto", "nombre"],
    });

    const idsRoles = new Map<string, number>();
    let totalIntegrantes = 0;
    for (const nombre of request.roles) {
      const cantidad = request.cantidadesPorRol[nombre];
      if (!Number.isInteger(cantidad) || cantidad <= 0) {
        throw new Error(`Debes indicar al menos 1 integrante para "${nombre}".`);
      }
      totalIntegrantes += cantidad;
      idsRoles.set(nombre, await this.obtenerIdPorNombre({
        tabla: "rol", campoId: "id_rol", valor: nombre,
        camposNombre: ["nombre_rol", "rol", "nombre"],
      }));
    }

    const idsHabilidades = new Map<string, number>();
    for (const nombre of request.habilidades) {
      idsHabilidades.set(nombre, await this.obtenerIdPorNombre({
        tabla: "habilidad", campoId: "id_habilidad", valor: nombre,
        camposNombre: ["nombre_habilidad", "habilidad", "nombre"],
      }));
    }

    const inicio = this.inicioDelDia(request.fechaInicio);
    const final = this.finalDelDia(request.fechaCierre);
    const abandono = new Date(final.getTime() - 2 * 86400000);
    const modelo = new ProjectModel(
      request.nombreProyecto.trim(), request.descripcion.trim(), idCreador,
      idCategoria, idTipoProyecto, request.objetivo.trim(),
      request.requisitos.trim(), totalIntegrantes, request.deseaDocente, "activo"
    );

    const proyectoCreado = await this.projectDatasource.createProject(modelo);
    const idProyecto = parseId(proyectoCreado.id_proyecto, "id_proyecto");

    // Roble no ofrece una transacción para estas tablas: a partir de aquí
    // cada operación puede haberse confirmado antes de un fallo posterior.
    try {
      for (const nombre of request.roles) {
        await this.rolesDatasource.createProjectRole(
          new ProjectRoleModel(idProyecto, idsRoles.get(nombre)!, request.cantidadesPorRol[nombre])
        );
      }
      for (const nombre of request.habilidades) {
        await this.skillsDatasource.createProjectSkill(
          new ProjectSkillModel(idProyecto, idsHabilidades.get(nombre)!)
        );
      }
      await this.convocatoriaDatasource.createConvocatoria(
        new ConvocatoriaModel(idProyecto, inicio, final, true, abandono)
      );
      await this.agregarCreadorComoLider(idProyecto, idCreador);
    } catch (cause) {
      throw new Error(
        `El proyecto ${idProyecto} se creó, pero falló una operación relacionada. Revisa los registros en Roble antes de reintentar.`,
        { cause }
      );
    }

    return { proyecto: proyectoCreado, id_proyecto: idProyecto };
  }
}
