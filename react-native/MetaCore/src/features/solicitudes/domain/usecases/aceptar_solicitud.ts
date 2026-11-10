import type { RegistroSolicitud } from "../entities/solicitud";
import type {
  IntegrantesParaSolicitudesRepository,
} from "../repositories/integrantes_para_solicitudes_repository";
import type { SolicitudRepository } from "../repositories/solicitud_repository";

function convertirEntero(valor: unknown): number | null {
  if (valor === null || valor === undefined) return null;
  const texto = String(valor).trim();
  if (!/^[+-]?\d+$/.test(texto)) return null;
  const numero = Number(texto);
  return Number.isSafeInteger(numero) ? numero : null;
}

export interface ResultadoAceptarSolicitud {
  solicitud: RegistroSolicitud;
  integrante: Record<string, unknown>;
}

export class AceptarSolicitud {
  constructor(
    private readonly solicitudRepository: SolicitudRepository,
    private readonly integranteRepository: IntegrantesParaSolicitudesRepository
  ) {}

  async execute(idSolicitud: number): Promise<ResultadoAceptarSolicitud> {
    const solicitud = await this.solicitudRepository.getSolicitudById(idSolicitud);

    if (!solicitud) {
      throw new Error(`No existe la solicitud con id ${idSolicitud}.`);
    }

    const estadoActual = String(solicitud["estado"] ?? "").trim().toLowerCase();
    if (estadoActual !== "pendiente") {
      throw new Error("Solo se pueden aceptar solicitudes pendientes.");
    }

    const idProyecto = convertirEntero(solicitud["id_proyecto"]);
    const idUsuario = convertirEntero(solicitud["id_usuario"]);
    const idProyectoRol = convertirEntero(solicitud["id_proyecto_rol"]);

    if (idProyecto === null || idUsuario === null || idProyectoRol === null) {
      throw new Error("La solicitud tiene datos inválidos.");
    }

    const idUsuarioAutenticado =
      await this.solicitudRepository.getIdUsuarioAutenticado();
    const idCreador = await this.solicitudRepository.getIdCreadorDelProyecto(
      idProyecto
    );

    if (idUsuarioAutenticado !== idCreador) {
      throw new Error("Solo el creador del proyecto puede aceptar esta solicitud.");
    }

    const proyectoRol = await this.solicitudRepository.getProyectoRolById(
      idProyectoRol
    );
    if (!proyectoRol) {
      throw new Error(`No existe el proyecto_rol ${idProyectoRol}.`);
    }

    // Garantiza que la relación de rol pertenece al proyecto solicitado.
    const idProyectoDelRol = convertirEntero(proyectoRol["id_proyecto"]);
    if (idProyectoDelRol !== null && idProyectoDelRol !== idProyecto) {
      throw new Error("El rol solicitado no pertenece al proyecto.");
    }

    const idRol = convertirEntero(proyectoRol["id_rol"]);
    const cantidadMaxima = convertirEntero(proyectoRol["cantidad"]);

    if (idRol === null || cantidadMaxima === null) {
      throw new Error("El proyecto_rol tiene datos inválidos.");
    }

    const integrantes = await this.integranteRepository.getIntegrantesByProject(
      idProyecto
    );
    const integrantesConEseRol = integrantes.filter(
      (integrante) => convertirEntero(integrante["id_rol"]) === idRol
    ).length;

    if (integrantesConEseRol >= cantidadMaxima) {
      throw new Error("El cupo para este rol ya está completo.");
    }

    const integranteExistente =
      await this.integranteRepository.getIntegranteByUserAndProject({
        idUsuario,
        idProyecto,
      });

    if (integranteExistente) {
      throw new Error("El usuario ya es integrante de este proyecto.");
    }

    // Respeta el orden Dart: crear integrante y después marcar como aceptada.
    const resultadoIntegrante = await this.integranteRepository.createIntegrante({
      idUsuario,
      idProyecto,
      idRol,
    });

    const resultadoSolicitud = await this.solicitudRepository.responderSolicitud({
      idSolicitud,
      nuevoEstado: "aceptado",
    });

    return { solicitud: resultadoSolicitud, integrante: resultadoIntegrante };
  }
}
