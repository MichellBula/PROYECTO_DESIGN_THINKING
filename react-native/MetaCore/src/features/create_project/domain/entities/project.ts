export class Project {
  constructor(
    public readonly nombre: string,
    public readonly descripcion: string,
    public readonly idCreador: number,
    public readonly idCategoria: number,
    public readonly idTipoProyecto: number,
    public readonly objetivo: string,
    public readonly requisitos: string,
    public readonly numIntegrantes: number,
    public readonly docenteAsesor: boolean,
    public readonly estado: string,
    public readonly calificacion: number | null = null
  ) {}
}
