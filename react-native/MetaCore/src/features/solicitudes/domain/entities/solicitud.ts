// Entidad del dominio; sin dependencias de React Native ni Roble.
export class Solicitud {
  constructor(
    public readonly idProyecto: number,
    public readonly idUsuario: number,
    public readonly estado: string,
    public readonly fechaEnviada: Date,
    public readonly fechaRespuesta: Date | null,
    public readonly idProyectoRol: number,
    public readonly comentario: string = ""
  ) {}
}

export type RegistroSolicitud = Record<string, unknown>;
